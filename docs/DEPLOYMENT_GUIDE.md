# Yebente Buna (የበንቴ ቡና) - Production Deployment Guide
**Authentic Ethiopian Coffee & Cultural Ceremony E-Commerce Platform for Kenya**

This guide walks you through registering a custom domain, purchasing hosting, setting up the Linux server environment, configuring Safaricom M-Pesa Daraja callbacks, and launching Yebente Buna in production.

---

## 1. Domain Registration & DNS Configuration

### A. Recommended Registrars
- **Kenyan Domains (`.co.ke`, `.ke`):**
  - [Truehost Kenya](https://truehost.co.ke)
  - [Kenya Website Experts](https://kenyawebexperts.com)
  - [Safaricom Domains](https://domains.safaricom.co.ke)
- **Pan-African & Global Domains (`.africa`, `.coffee`, `.com`, `.store`):**
  - [Namecheap](https://namecheap.com)
  - [Cloudflare Registrar](https://cloudflare.com)

### B. DNS Record Setup
Once your hosting server is provisioned and you receive your public IPv4 address (e.g. `197.248.xxx.xxx` or `165.22.xxx.xxx`), add the following DNS records in your domain registrar's DNS management panel:

| Type | Host | Value / Target | TTL |
| :--- | :--- | :--- | :--- |
| **A** | `@` (root) | `<YOUR_SERVER_PUBLIC_IP>` | Auto / 300s |
| **A** | `www` | `<YOUR_SERVER_PUBLIC_IP>` | Auto / 300s |
| **CNAME** | `mpesa` | `@` (optional dedicated callback subdomain) | Auto |

---

## 2. Recommended Hosting VPS Specifications

To handle traffic spikes, Hotwire Turbo Stream connections, and background M-Pesa IPN callback queues:

- **Recommended Cloud Providers:**
  - **DigitalOcean** (Frankfurt / London / Bangalore droplets or South Africa region)
  - **AWS EC2 / Lightsail** (Nairobi Local Zone `af-south-1` / Cape Town)
  - **Hetzner Cloud** (CPX21 or CPX31 - high performance / low cost)
  - **Linode / Akamai**
- **Hardware Sizing:**
  - **Minimum:** 2 vCPU, 2 GB RAM, 40 GB NVMe SSD (Ubuntu 22.04 or 24.04 LTS)
  - **Recommended:** 2 vCPU, 4 GB RAM (allows smooth in-memory Puma caching and asset precompilation)

---

## 3. Server Provisioning & Package Installation

Connect to your clean server via SSH:
```bash
ssh root@<YOUR_SERVER_IP>
```

### Step 3.1: System Update & Core Packages
```bash
apt update && apt upgrade -y
apt install -y curl git build-essential libpq-dev postgresql postgresql-contrib \
  nginx certbot python3-certbot-nginx tzdata libyaml-dev libffi-dev libssl-dev zlib1g-dev
```

### Step 3.2: Set System Timezone to Africa/Nairobi
```bash
timedatectl set-timezone Africa/Nairobi
timedatectl status
```

### Step 3.3: Configure PostgreSQL Database
```bash
sudo -u postgres psql -c "CREATE USER yebente WITH PASSWORD 'StrongDatabasePassword123!';"
sudo -u postgres psql -c "CREATE DATABASE yebente_buna_production OWNER yebente;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE yebente_buna_production TO yebente;"
```

### Step 3.4: Install Ruby 3.2.3
```bash
# Install rbenv or ruby-build
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv install 3.2.3
rbenv global 3.2.3
gem install bundler
```

---

## 4. Code Deployment & Configuration

### Step 4.1: Clone the Repository
```bash
mkdir -p /var/www/yebente
cd /var/www/yebente
git clone https://github.com/altradits/buna.git current
cd current
```

### Step 4.2: Configure Production Environment (`.env`)
Create the production `.env` file:
```bash
cp .env.example .env
nano .env
```
Ensure the following production credentials are set:
```bash
RAILS_ENV=production
PORT=3000
SECRET_KEY_BASE=$(bundle exec rails secret)

# Domain & Merchant Contact
APP_HOST="yourdomain.co.ke"
APP_URL="https://yourdomain.co.ke"
DEFAULT_MERCHANT_PHONE="+254707172370"
ADMIN_EMAIL="yebente@gmail.com"

# Safaricom M-Pesa Daraja Production Credentials
MPESA_ENVIRONMENT="production"
MPESA_CONSUMER_KEY="<YOUR_PRODUCTION_CONSUMER_KEY>"
MPESA_CONSUMER_SECRET="<YOUR_PRODUCTION_CONSUMER_SECRET>"
MPESA_SHORTCODE="<YOUR_PAYBILL_OR_TILL>"
MPESA_PASSKEY="<YOUR_PRODUCTION_PASSKEY>"
MPESA_CALLBACK_URL="https://yourdomain.co.ke/api/v1/mpesa/callback"

# Database
DATABASE_URL="postgres://yebente:StrongDatabasePassword123!@localhost:5432/yebente_buna_production"
```

### Step 4.3: Install Gems & Precompile Assets
```bash
bundle install --without development test
bundle exec rails assets:precompile RAILS_ENV=production
```

### Step 4.4: Run Migrations & Seed Product Taxonomy
```bash
bundle exec rails db:prepare RAILS_ENV=production
bundle exec rails db:seed RAILS_ENV=production
```
*This seeds the entire catalog: Sidamo, Yirgacheffe, Harrar, Limu, and Kaffa beans, handcrafted Gondar Jebenas, Menkeshkesh pans, Saba Sini cups, Rekebot tables, and Tigray Frankincense.*

---

## 5. Nginx Reverse Proxy & Free Let's Encrypt SSL

### Step 5.1: Copy Nginx Config
```bash
cp config/nginx.conf.example /etc/nginx/sites-available/yebente
sed -i 's/yourdomain.com/yourdomain.co.ke/g' /etc/nginx/sites-available/yebente
ln -s /etc/nginx/sites-available/yebente /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl reload nginx
```

### Step 5.2: Issue Free Let's Encrypt SSL Certificate
```bash
certbot --nginx -d yourdomain.co.ke -d www.yourdomain.co.ke --non-interactive --agree-tos -m yebente@gmail.com
```

---

## 6. Systemd Services (Automatic Restart on Reboot)

### Step 6.1: Setup Web Server Service
```bash
cp config/systemd/yebente-web.service.example /etc/systemd/system/yebente-web.service
# Edit path and user if needed
systemctl daemon-reload
systemctl enable yebente-web
systemctl start yebente-web
```

### Step 6.2: Setup Background Worker Service (Solid Queue)
```bash
cp config/systemd/yebente-worker.service.example /etc/systemd/system/yebente-worker.service
systemctl daemon-reload
systemctl enable yebente-worker
systemctl start yebente-worker
```

Verify service health:
```bash
systemctl status yebente-web
systemctl status yebente-worker
curl -I https://yourdomain.co.ke/up
```

---

## 7. Safaricom M-Pesa Go-Live Checklist

1. Log in to [Safaricom Daraja Portal](https://developer.safaricom.co.ke).
2. Go to **Go Live** and submit your business Till or Paybill number (`174379` or your business Till).
3. Set your Callback URL: `https://yourdomain.co.ke/api/v1/mpesa/callback`.
4. Test an STK push transaction using the store checkout with your phone `+254707172370`.
5. Monitor logs in real time:
   ```bash
   journalctl -u yebente-web -f
   journalctl -u yebente-worker -f
   ```
