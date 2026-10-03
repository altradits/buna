# Yebente Buna (የበንቴ ቡና)
**Authentic Ethiopian Coffee Ceremony & Cultural Artifacts Exported Direct to Kenya**

🌐 **Live Demo / Production:** [https://buna-beta.vercel.app](https://buna-beta.vercel.app)

[![Deployed on Vercel](https://img.shields.io/badge/Deployed%20on-Vercel-black?style=flat&logo=vercel)](https://buna-beta.vercel.app)
[![Ruby on Rails](https://img.shields.io/badge/Ruby_on_Rails-7.1-CC0000.svg)](https://rubyonrails.org)
[![Safaricom M-Pesa](https://img.shields.io/badge/Payment-Safaricom_M--Pesa_Daraja-00A859.svg)](https://developer.safaricom.co.ke)
[![Timezone](https://img.shields.io/badge/Timezone-Africa%2FNairobi-D48B38.svg)]()
[![Currency](https://img.shields.io/badge/Currency-KES_%7C_ETB-140B07.svg)]()

---

## 1. Application Core Identity & Branding

* **Application Name:** **Yebente Buna** (የበንቴ ቡና)
* **Niche:** Premium single-origin authentic Ethiopian coffees, traditional brewing artifacts, and cultural experiential accessories exported directly from Ethiopian regional hubs to the Kenyan market.
* **Target Audience:** Coffee connoisseurs, cultural enthusiasts, diaspora communities, and culinary explorers in Kenya (Nairobi, Mombasa, Nakuru, Eldoret, Kisumu) seeking an authentic, unadulterated Ethiopian "Buna" ceremony experience.
* **Visual Palette:** Warm, earthy, premium color palette rooted in coffee culture:
  * `buna-dark` (`#140B07`): Deep obsidian roast
  * `buna-roast` (`#3A2016`): Roasted whole bean mahogany
  * `buna-terracotta` (`#9E472A`): Handcrafted Gondar clay Jebena
  * `buna-amber` (`#D48B38`): Crema & Frankincense ember glow
  * `buna-gold` (`#E5A652`): Queen of Sheba (Saba) gold motif
  * `buna-sand` (`#EFE7DA`): Handwoven Ketema grass reed tone
  * `safaricom-green` (`#00A859`): Official Safaricom M-Pesa checkout action

---

## 2. Payment, Regional Localization & Contacts

* **Primary Payment Gateway:** Fully integrated **Safaricom M-Pesa Daraja API**:
  * **M-Pesa Express (STK Push):** Customer enters Safaricom number and enters PIN on their handset.
  * **Asynchronous Webhook Processing:** Background worker (Solid Queue) processes IPN callbacks with instant Hotwire Turbo Stream UI updates.
  * **C2B Paybill Fallback:** Paybill `174379` validation and confirmation hooks with account reference matching.
* **Operational Configurations:**
  * **Default Merchant / Support Hotline:** `+254707172370`
  * **System Administrator & Notification Email:** `yebente@gmail.com`
* **Regional Localization:**
  * **Base Currency:** Kenyan Shilling (**KES** - `KSh`) for front-end transactions.
  * **Multi-Currency Toggle:** Ethiopian Birr (**ETB** - `ብር`) with real-time underlying exchange rate conversion.
  * **Application Timezone:** `Africa/Nairobi` (EAT, UTC+3).
* **Cross-Border Logistics Module:**
  * Architectural routing service (`Logistics::EastAfricanCourierService`) linking **Addis Ababa Bole Central Hub** ➔ **Moyale One-Stop Border Post (OSBP) Customs** ➔ **Nairobi Distribution Center** ➔ Doorstep delivery via **Fargo Courier**, **Sendy**, or **DHL East Africa**.

---

## 3. Product Taxonomy & Seeded Offerings

Populated with 6 rich categories capturing the traditional 3-round Buna ritual (*Abol*, *Tona*, *Baraka*):

1. **Coffee Varieties:**
   * Single-origin beans from **Sidamo**, **Yirgacheffe**, **Harrar**, **Limu**, and **Kaffa** zones.
   * Available in **Raw Green Beans** (for ceremonial pan roasting), **Roasted Whole Beans**, and **Fine Ground** (calibrated for Jebena decoction).
   * Models store roast profile (*Light*, *Medium*, *Traditional Dark Roast*), processing (*Washed*, *Natural*), elevation, and tasting notes.
2. **Traditional Brewing Hardware:**
   * Handcrafted clay **Jebena pots (ጀበና)** from Gondar and Harar.
   * Perforated iron roasting pans (**Menkeshkesh / መንከሽከሽ**).
   * Charcoal heating braziers (**Fernello / ፈርኔሎ**).
   * Thin-necked brass pouring kettles.
3. **Serving Ware:**
   * Handleless ceramic coffee cups (**Sini or Cini / ሲኒ**) with 18k gold-trimmed Saba and Habesha floral motifs (6-piece and 12-piece sets).
   * Two-tiered hand-carved wooden ceremony tables/trays (**Rekebot / ረከቦት**) with incense storage drawers.
   * Artisan East African olive wood stirring rods (**Mashesha / ማሼሻ**).
4. **Modern & Traditional Milling:**
   * Heavy clamp-mount cast-iron manual hand grinders.
   * Electric conical burr grinders with micro-stepped Jebena calibration.
   * Handcrafted brass travel grinders.
5. **Sensory & Mood Enhancers:**
   * Earthen terracotta incense burners (**Gidich / Itan Mafacha / ግድች**).
   * Premium Grade-1 **Royal Tigray Frankincense (Olibanum / Etan / ዕጣን)**.
   * Pure **Ogaden Myrrh (Karbe / ከርቤ)** resins.
   * Fresh air-dried **Rue herb (Tenadam / ጤናዳም)** stems and seeds.
   * Ceremonial **Korerima** (Ethiopian black cardamom, ginger, clove) spice blend.
   * Wild olive wood chips and natural coconut shell charcoal.
6. **Spatial Aesthetics & Decor:**
   * Handwoven **Ketema ceremonial floor mats (ቄጠማ)** (natural grass substitute).
   * Hand-spun cotton table runners with **Tibeb (ጥበብ)** embroidery and gold thread.
   * Traditional carved wooden low stools (**Barchuma / በርጩማ**).
   * Embroidered velvet ceremony floor cushions.

---

## 4. Technical Architecture

* **Framework:** Ruby on Rails 7.1+
* **Front-End Interactivity:** Hotwire (Turbo Drive, Turbo Frames, Turbo Streams) + Stimulus.js for instant, reactive single-page feel without bloated JavaScript frameworks.
* **Database:** PostgreSQL with relational foreign keys, multi-currency decimal precision, and optimized indexing.
* **Styling:** Tailwind CSS with custom coffee-culture design system.
* **Background Processing:** Solid Queue (Rails 7.1 native database-backed asynchronous worker pattern).
* **Payment Flow:**
  ```text
  Customer Checkout ➔ Safaricom Daraja STK Push ➔ Customer Handset (PIN) 
       ➔ Daraja IPN Webhook ➔ Solid Queue Background Worker 
       ➔ Order Marked Paid ➔ Turbo Stream Replaces UI Live ➔ Courier Manifest Dispatched
  ```

---

## 5. Domain, Hosting & Deployment Setup

To deploy Yebente Buna on your own purchased domain and VPS hosting:

1. **Buy Domain:** Register your domain (e.g. `yebente.africa` or `yebentebuna.co.ke`) on Truehost, Safaricom Domains, or Namecheap.
2. **Buy VPS Hosting:** Provision an Ubuntu 22.04 / 24.04 server on DigitalOcean, AWS EC2, or Hetzner.
3. **Point DNS:** Add DNS `A` records pointing `@` and `www` to your server's IP address.
1. **Deploy to Vercel (Container Images):**
   * Live deployment: [https://buna-beta.vercel.app](https://buna-beta.vercel.app)
   * The app is configured with `Dockerfile.vercel` for serverless container deployment.
   * To deploy updates: `npx vercel --prod`
   * To attach managed PostgreSQL: set `DATABASE_URL` in your Vercel project environment variables.

2. **Deploy to VPS (Ubuntu/Nginx):**
   * Step-by-step instructions are documented in [docs/DEPLOYMENT_GUIDE.md](docs/DEPLOYMENT_GUIDE.md):
     * Setting up Ruby 3.2, PostgreSQL, and Nginx.
     * Issuing free Let's Encrypt SSL certificates.
     * Configuring Systemd services for automated restart.
     * Going live on the Safaricom Daraja portal.

---

## 6. Local Quickstart

```bash
# 1. Clone repository
git clone https://github.com/altradits/buna.git
cd buna

# 2. Setup dependencies and environment
bin/setup

# 3. Start development server
bin/rails server -p 3000
```

Access the storefront at `http://localhost:3000` or admin dashboard at `http://localhost:3000/admin`.
