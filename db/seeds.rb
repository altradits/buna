# ==============================================================================
# YEBENTE BUNA - DATABASE SEEDING ENGINE
# Authentic Ethiopian Coffee Ceremony & Cultural Artifacts for Kenya
# ==============================================================================

puts "Cleaning existing product taxonomy and ceremony artifacts..."
OrderItem.destroy_all
Order.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

# 1. System Administrator & Merchant User
admin_user = User.create!(
  email: "yebente@gmail.com",
  password: "Password123!",
  password_confirmation: "Password123!",
  full_name: "Yebente Merchant Administrator",
  phone_number: "+254707172370",
  role: "admin",
  preferred_currency: "KES",
  address_line1: "Yebente Sourcing & Distribution Hub",
  address_line2: "Commercial Street, Industrial Area",
  city: "Nairobi",
  county: "Nairobi",
  postal_code: "00100"
)
puts "✓ Created Administrator User: #{admin_user.email} (Phone: #{admin_user.phone_number})"

# 2. Categories Creation
categories = {
  coffee: Category.create!(
    name: "Coffee Varieties",
    amharic_name: "የቡና ዝርያዎች",
    slug: "coffee-varieties",
    description: "Heirloom single-origin beans from Ethiopia's prime highlands: Sidamo, Yirgacheffe, Harrar, Limu, and Kaffa. Available in Raw Green Beans, Roasted Whole Beans, and Fresh Ground.",
    icon: "coffee",
    sort_order: 1
  ),
  brewing: Category.create!(
    name: "Traditional Brewing Hardware",
    amharic_name: "የባህላዊ ቡና ማፍያ እቃዎች",
    slug: "traditional-brewing-hardware",
    description: "Authentic hand-thrown clay coffee pots (Jebena), perforated iron roasting pans (Menkeshkesh), and charcoal heating braziers (Fernello).",
    icon: "pot",
    sort_order: 2
  ),
  serving: Category.create!(
    name: "Serving Ware",
    amharic_name: "የቡና ማቅረቢያ እቃዎች",
    slug: "serving-ware",
    description: "Handleless ceramic cups (Sini / Cini) with gold-trimmed motifs, matching porcelain serving tables (Rekebot), and stirring rods.",
    icon: "cup",
    sort_order: 3
  ),
  milling: Category.create!(
    name: "Modern & Traditional Milling",
    amharic_name: "የቡና መፍጫዎች",
    slug: "modern-traditional-milling",
    description: "Manual hand grinders and electrical conical burr grinders engineered for the powdery fine grind essential for clay Jebena extraction.",
    icon: "grinder",
    sort_order: 4
  ),
  sensory: Category.create!(
    name: "Sensory & Mood Enhancers",
    amharic_name: "ዕጣን እና ባህላዊ ቅመሞች",
    slug: "sensory-mood-enhancers",
    description: "Earthen incense burners (Gidich / Mubakhar), Royal Tigray Frankincense (Olibanum), Myrrh, Tenadam (Rue) herb, and Korerima blends.",
    icon: "incense",
    sort_order: 5
  ),
  decor: Category.create!(
    name: "Spatial Aesthetics & Decor",
    amharic_name: "የባህል ማስጌጫ እና ጨርቃጨርቅ",
    slug: "spatial-aesthetics-decor",
    description: "Handwoven Ketema floor mats, gold-threaded Tibeb embroidered runners, Netela fabrics, and low-slung wooden Barchuma stools.",
    icon: "decor",
    sort_order: 6
  )
}
puts "✓ Created 6 Cultural Product Categories."

# 3. Product Seeding: Category 1 - Coffee Varieties (Sidamo, Yirgacheffe, Harrar, Limu, Kaffa)
# Each zone available across formats (Raw Green Beans, Roasted Whole Beans, Ground)
coffee_varieties = [
  # --- YIRGACHEFFE ---
  {
    category: categories[:coffee],
    name: "Yirgacheffe Kochere Heirloom (Roasted Whole Beans)",
    amharic_name: "ይርጋጨፌ ኮቸሬ",
    slug: "yirgacheffe-kochere-roasted-whole-beans",
    sku: "YB-COF-YIRG-WHL-01",
    short_description: "Vibrant floral acidity with bergamot, sweet peach, and jasmine blossoms.",
    description: "Cultivated in the misty slopes of Gedeo zone at elevations surpassing 2,100 meters. Washed with pure mountain stream water, this roast showcases the sublime floral complexity that made Yirgacheffe the world's most revered single-origin bean.",
    price_kes: 1850.00,
    price_etb: 1628.00,
    stock_quantity: 85,
    weight_grams: 500,
    is_featured: true,
    origin_zone: "Yirgacheffe",
    roast_profile: "Medium",
    bean_format: "Roasted Whole Beans",
    processing_method: "Washed",
    elevation: "2,000m - 2,200m ASL",
    tasting_notes: "Jasmine Floral, Bergamot Citrus, Sweet Peach, Honey",
    cultural_significance: "Prized in Addis Ababa for the Abol (first round) extraction during Sunday morning Buna ceremonies.",
    image_url: "/images/products/yirgacheffe-kochere-coffee.jpg"
  },
  {
    category: categories[:coffee],
    name: "Yirgacheffe Kochere (Jebena Fine Ground)",
    amharic_name: "ይርጋጨፌ ዱቄት ቡና",
    slug: "yirgacheffe-kochere-fine-ground",
    sku: "YB-COF-YIRG-GRN-02",
    short_description: "Ultra-fine powdery grind calibrated precisely for the long neck of the clay Jebena.",
    description: "Freshly roasted and pulverised to a flour-like texture, allowing complete colloidal emulsion when brewed slowly over charcoal embers.",
    price_kes: 1950.00,
    price_etb: 1716.00,
    stock_quantity: 60,
    weight_grams: 500,
    is_featured: false,
    origin_zone: "Yirgacheffe",
    roast_profile: "Medium",
    bean_format: "Ground",
    processing_method: "Washed",
    elevation: "2,000m - 2,200m ASL",
    tasting_notes: "Bergamot, Dried Apricot, Meyer Lemon, Jasmine",
    cultural_significance: "Pre-milled for Kenyan coffee lovers seeking instant authentic extraction without a traditional mortar.",
    image_url: "/images/products/coffee-ground.jpg"
  },
  {
    category: categories[:coffee],
    name: "Yirgacheffe Grade 1 (Raw Green Beans for Pan Roasting)",
    amharic_name: "ይርጋጨፌ አረንጓዴ ቡና",
    slug: "yirgacheffe-grade-1-raw-green-beans",
    sku: "YB-COF-YIRG-RAW-03",
    short_description: "Dense, hand-sorted raw green beans ready for live ritual roasting on the Menkeshkesh.",
    description: "Unroasted specialty green coffee beans carefully dried on raised African beds. Perfect for executing the ceremonial wash, roast, and aromatic smoke wafting ritual at home in Kenya.",
    price_kes: 1550.00,
    price_etb: 1364.00,
    stock_quantity: 110,
    weight_grams: 1000,
    is_featured: false,
    origin_zone: "Yirgacheffe",
    roast_profile: "Light",
    bean_format: "Raw Green Beans",
    processing_method: "Washed",
    elevation: "2,100m ASL",
    tasting_notes: "Crisp Green Apple, Lime Zest, Floral Jasmine (Post-Roast)",
    cultural_significance: "Essential for the traditional host who roasts beans in presence of honored guests.",
    image_url: "/images/products/coffee-green-beans.jpg"
  },

  # --- SIDAMO ---
  {
    category: categories[:coffee],
    name: "Sidamo Grade 2 Bensa (Traditional Dark Roast)",
    amharic_name: "ሲዳሞ ቤንሳ ጥቁር ቆሎ ቡና",
    slug: "sidamo-grade-2-bensa-traditional-dark-roast",
    sku: "YB-COF-SIDA-DRK-01",
    short_description: "Rich body with dark cocoa, ripe blackberry, and cane sugar sweetness.",
    description: "From the high plateaus of Sidama, roasted slowly to a glistening traditional dark profile that mirrors the pan-roast style of Ethiopian villages. Heavy velvety mouthfeel that stands up magnificently to a sprig of fresh Rue (Tenadam).",
    price_kes: 1750.00,
    price_etb: 1540.00,
    stock_quantity: 95,
    weight_grams: 500,
    is_featured: true,
    origin_zone: "Sidamo",
    roast_profile: "Traditional Dark Roast",
    bean_format: "Roasted Whole Beans",
    processing_method: "Natural",
    elevation: "1,900m - 2,150m ASL",
    tasting_notes: "Dark Chocolate, Ripe Blackberry, Brown Sugar, Cardamom Spice",
    cultural_significance: "The quintessential coffee for multi-generational household ceremonies across the Horn of Africa.",
    image_url: "/images/products/sidamo-bensa-coffee.jpg"
  },
  {
    category: categories[:coffee],
    name: "Sidamo Bensa (Fine Ground Format)",
    amharic_name: "ሲዳሞ የተፈጨ ቡና",
    slug: "sidamo-bensa-ground-format",
    sku: "YB-COF-SIDA-GRN-02",
    short_description: "Full-bodied ground roast, ideal for Jebena decoction or moka pot.",
    description: "Deep, naturally sweet Sidama beans ground specifically for hot water steeping.",
    price_kes: 1800.00,
    price_etb: 1584.00,
    stock_quantity: 75,
    weight_grams: 500,
    is_featured: false,
    origin_zone: "Sidamo",
    roast_profile: "Traditional Dark Roast",
    bean_format: "Ground",
    processing_method: "Natural",
    elevation: "1,950m ASL",
    tasting_notes: "Black Cherry, Cacao Nibs, Molasses",
    cultural_significance: "Preferred base when serving coffee with salt and spiced clarified butter (Niter Kibbeh).",
    image_url: "/images/products/coffee-ground.jpg"
  },

  # --- HARRAR ---
  {
    category: categories[:coffee],
    name: "Ancient Harrar Longberry Wild (Traditional Dark Roast)",
    amharic_name: "የሐረር ሎንግበሪ ጥቁር ቡና",
    slug: "ancient-harrar-longberry-traditional-dark-roast",
    sku: "YB-COF-HARR-DRK-01",
    short_description: "Exotic sun-dried natural with pronounced wild blueberry, dried fig, and leather.",
    description: "Harrar is legendary. Sun-dried in its fruit on the sun-drenched terraced hills of eastern Ethiopia, the elongated Longberry beans produce a winey, full-bodied cup with a distinct blueberry jam aroma.",
    price_kes: 2100.00,
    price_etb: 1848.00,
    stock_quantity: 50,
    weight_grams: 500,
    is_featured: true,
    origin_zone: "Harrar",
    roast_profile: "Traditional Dark Roast",
    bean_format: "Roasted Whole Beans",
    processing_method: "Natural",
    elevation: "1,800m - 2,000m ASL",
    tasting_notes: "Wild Blueberry, Dark Raisin, Syrupy Body, Warm Cardamom",
    cultural_significance: "Cultivated in the historic walled city of Harar Jugol, renowned for ancient Sufi coffee traditions.",
    image_url: "/images/products/ancient-harrar-coffee.jpg"
  },
  {
    category: categories[:coffee],
    name: "Ancient Harrar Raw Green Beans (Sun-Dried Natural)",
    amharic_name: "የሐረር አረንጓዴ ቡና",
    slug: "ancient-harrar-raw-green-beans",
    sku: "YB-COF-HARR-RAW-02",
    short_description: "Naturally processed raw Longberry beans boasting high fruit density.",
    description: "Imported directly from Harar micro-lots for artisanal roasters and home ceremony purists in Kenya.",
    price_kes: 1700.00,
    price_etb: 1496.00,
    stock_quantity: 80,
    weight_grams: 1000,
    is_featured: false,
    origin_zone: "Harrar",
    roast_profile: "Medium",
    bean_format: "Raw Green Beans",
    processing_method: "Natural",
    elevation: "1,850m ASL",
    tasting_notes: "Dried Strawberry, Cocoa Dust, Tobacco Leaf",
    cultural_significance: "The foundation of classic Ethiopian domestic pan roasting.",
    image_url: "/images/products/coffee-green-beans.jpg"
  },

  # --- LIMU ---
  {
    category: categories[:coffee],
    name: "Limu Highland Forest Estate (Medium Roast)",
    amharic_name: "የሊሙ ደን ቡና",
    slug: "limu-highland-forest-estate-medium-roast",
    sku: "YB-COF-LIMU-MED-01",
    short_description: "Low-acid balanced profile with sweet apricot, nectarine, and spiced wine notes.",
    description: "Sourced from the forested southwestern highlands of Limu. This washed coffee is praised for its round body, pleasant citrus sweetness, and spicy undertones that complement afternoon gatherings.",
    price_kes: 1650.00,
    price_etb: 1452.00,
    stock_quantity: 70,
    weight_grams: 500,
    is_featured: false,
    origin_zone: "Limu",
    roast_profile: "Medium",
    bean_format: "Roasted Whole Beans",
    processing_method: "Washed",
    elevation: "1,750m - 1,950m ASL",
    tasting_notes: "Sweet Apricot, Nectarine, Lemongrass, Warm Spice",
    cultural_significance: "A comforting daily drinker favored across Jimma and Oromia.",
    image_url: "/images/products/limu-forest-coffee.jpg"
  },

  # --- KAFFA ---
  {
    category: categories[:coffee],
    name: "Kaffa Biosphere Reserve Ancient Heritage (Traditional Dark Roast)",
    amharic_name: "የካፋ ጥንታዊ የዱር ቡና",
    slug: "kaffa-biosphere-reserve-ancient-heritage",
    sku: "YB-COF-KAFF-DRK-01",
    short_description: "Earthy, wild, and intensely aromatic from the genetic birthplace of Coffea Arabica.",
    description: "Harvested directly from wild semi-forest trees in the Kaffa Biosphere Reserve, where coffee was first discovered by the shepherd Kaldi. Packed with deep wild berry notes, cedarwood, and rich earthen warmth.",
    price_kes: 2250.00,
    price_etb: 1980.00,
    stock_quantity: 45,
    weight_grams: 500,
    is_featured: true,
    origin_zone: "Kaffa",
    roast_profile: "Traditional Dark Roast",
    bean_format: "Roasted Whole Beans",
    processing_method: "Natural",
    elevation: "1,600m - 1,900m ASL",
    tasting_notes: "Wild Red Current, Cedar, Earthy Truffle, Black Fig",
    cultural_significance: "Direct connection to the ancestral origins of Buna culture.",
    image_url: "/images/products/kaffa-biosphere-coffee.jpg"
  }
]

coffee_varieties.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Coffee Varieties across Sidamo, Yirgacheffe, Harrar, Limu, and Kaffa."

# 4. Product Seeding: Category 2 - Traditional Brewing Hardware (Jebena, Menkeshkesh, Brazier, Kettles)
brewing_hardware = [
  {
    category: categories[:brewing],
    name: "Handcrafted Gondar Clay Jebena (ጀበና)",
    amharic_name: "የጎንደር ባህላዊ ሸክላ ጀበና",
    slug: "handcrafted-gondar-clay-jebena",
    sku: "YB-HRD-JEB-GON-01",
    short_description: "Authentic hand-molded black clay coffee pot with graceful spherical base and pouring spout.",
    description: "Crafted by master potters using natural iron-rich riverbed clay from Gondar, smoked in eucalyptus wood to achieve its signature jet-black luster. Features a straw neck stopper (Guffa) that filters grounds naturally during pouring.",
    price_kes: 3400.00,
    price_etb: 2992.00,
    stock_quantity: 35,
    weight_grams: 1200,
    is_featured: true,
    material: "Hand-Molded Smoked Black Clay",
    dimensions: "Height: 28cm, Belly Diameter: 18cm, Capacity: 1.2 Liters",
    cultural_significance: "The sacred centerpiece of the Buna ceremony. The rounded belly allows fine grounds to settle at the bottom during standing, ensuring a crystal-clear pour from the high spout.",
    usage_instructions: "Season with coffee grounds and boiling water before initial brew. Never wash with synthetic detergents; rinse only with warm water and air-dry upside down.",
    image_url: "/images/products/jebena-gondar.jpg"
  },
  {
    category: categories[:brewing],
    name: "Harari Flat-Bottom Clay Jebena with Tribal Inlay",
    amharic_name: "የሐረር ጠፍጣፋ ጀበና",
    slug: "harari-flat-bottom-clay-jebena",
    sku: "YB-HRD-JEB-HAR-02",
    short_description: "Traditional Harari-style clay pot with stable flat bottom and geometric neck carvings.",
    description: "Unlike high-necked northern Jebenas, the Harari variant features a broader base optimized for direct heat distribution on ceramic charcoal braziers.",
    price_kes: 3200.00,
    price_etb: 2816.00,
    stock_quantity: 25,
    weight_grams: 1100,
    is_featured: false,
    material: "Terracotta Clay with Ochre Burnishing",
    dimensions: "Height: 24cm, Capacity: 1.0 Liter",
    cultural_significance: "Reflects the architectural and decorative motifs of the old city of Harar.",
    usage_instructions: "Place directly on gentle charcoal or gas burner diffuser ring.",
    image_url: "/images/products/jebena-harari.jpg"
  },
  {
    category: categories[:brewing],
    name: "Traditional Menkeshkesh Iron Roasting Pan (መንከሽከሽ)",
    amharic_name: "ባህላዊ የብረት መንከሽከሽ",
    slug: "traditional-menkeshkesh-iron-roasting-pan",
    sku: "YB-HRD-MNK-01",
    short_description: "Perforated wrought-iron roasting pan with handcrafted turned wooden handle.",
    description: "The perforated base allows uniform heat circulation from charcoal coals while venting the chaff cleanly. Designed with a long stay-cool wooden handle to permit continuous swirling of green beans.",
    price_kes: 2200.00,
    price_etb: 1936.00,
    stock_quantity: 40,
    weight_grams: 800,
    is_featured: true,
    material: "Wrought Iron with Hardwood Handle",
    dimensions: "Pan Diameter: 22cm, Handle Length: 32cm",
    cultural_significance: "Used during the second ceremonial phase where newly roasted beans are walked around the room so guests may inhale the fragrant smoke.",
    usage_instructions: "Lightly coat with vegetable oil before storing to prevent oxidation.",
    image_url: "/images/products/menkeshkesh-pan.jpg"
  },
  {
    category: categories[:brewing],
    name: "Ceremonial Charcoal Fernello Brazier (ፈርኔሎ)",
    amharic_name: "የከሰል ማፍያ ፈርኔሎ",
    slug: "ceremonial-charcoal-fernello-brazier",
    sku: "YB-HRD-FRN-01",
    short_description: "Heavy clay and iron charcoal stove designed to support the Jebena and incense burner.",
    description: "Engineered to deliver sustained low-smolder heat required for gentle multi-stage decoction of the coffee grinds without scalding the brew.",
    price_kes: 2800.00,
    price_etb: 2464.00,
    stock_quantity: 20,
    weight_grams: 3200,
    is_featured: false,
    material: "Refractory Clay & Reinforced Iron Frame",
    dimensions: "Top Diameter: 26cm, Height: 20cm",
    cultural_significance: "Provides the rhythmic warmth and incense dispersal that sets the spiritual mood.",
    usage_instructions: "Use with hardwood charcoal or coconut husk briquettes indoors with adequate ventilation.",
    image_url: "/images/products/fernello-brazier.jpg"
  },
  {
    category: categories[:brewing],
    name: "Thin-Necked Brass Pouring Kettle (ብረት ማፍያ)",
    amharic_name: "ባህላዊ የናስ ኬትል",
    slug: "thin-necked-brass-pouring-kettle",
    sku: "YB-HRD-KTL-01",
    short_description: "Polished brass water heating vessel with elongated gooseneck spout.",
    description: "Used to heat fresh water prior to introducing it to the Jebena pot and to top up water during the Tona and Baraka rounds.",
    price_kes: 2900.00,
    price_etb: 2552.00,
    stock_quantity: 30,
    weight_grams: 950,
    is_featured: false,
    material: "Spun Solid Brass",
    dimensions: "Capacity: 1.5 Liters",
    cultural_significance: "Maintains a steady supply of boiling water without interrupting the ceremony.",
    usage_instructions: "Rinse with lemon and salt water to maintain radiant brass patina.",
    image_url: "/images/products/brass-pouring-kettle.jpg"
  }
]

brewing_hardware.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Traditional Brewing Hardware (Jebenas, Menkeshkesh, Fernello)."

# 5. Product Seeding: Category 3 - Serving Ware (Sini cups, Rekebot tables, Stirring rods)
serving_ware = [
  {
    category: categories[:serving],
    name: "Saba Motif Ceramic Sini Set (ሲኒ) - Set of 6 with Saucers",
    amharic_name: "የሳባ ዲዛይን ሲኒ እና ሰሃን (6 ቁራጭ)",
    slug: "saba-motif-ceramic-sini-set-of-6",
    sku: "YB-SRV-SINI-SAB-06",
    short_description: "Handleless porcelain coffee cups featuring the gold-rimmed Queen of Sheba (Saba) geometric motif.",
    description: "Authentic Ethiopian Sini cups designed without handles to encourage the drinker to cradle the cup in the palms and appreciate the tactile warmth of the Buna.",
    price_kes: 2600.00,
    price_etb: 2288.00,
    stock_quantity: 60,
    weight_grams: 900,
    is_featured: true,
    material: "Glazed Porcelain with 18k Gold Trim Inlay",
    dimensions: "Cup Capacity: 65ml, Diameter: 6cm, Height: 5cm",
    cultural_significance: "The Saba motif is a national cultural emblem symbolizing ancient royal heritage and Ethiopian hospitality.",
    usage_instructions: "Hand wash gently with mild soap to preserve gold foil border.",
    image_url: "/images/products/sini-cups-set.jpg"
  },
  {
    category: categories[:serving],
    name: "Classic Cini Set with Red & Green Habesha Floral Motif (Set of 12)",
    amharic_name: "የሀበሻ አበባ ዲዛይን ሲኒ (12 ቁራጭ)",
    slug: "classic-cini-set-habesha-floral-12-piece",
    sku: "YB-SRV-SINI-FLR-12",
    short_description: "Large 12-piece gathering set featuring traditional green, yellow, and crimson floral prints.",
    description: "Designed for welcoming extended family and neighborhood gatherings where no cup is ever allowed to remain empty.",
    price_kes: 3800.00,
    price_etb: 3344.00,
    stock_quantity: 40,
    weight_grams: 1600,
    is_featured: false,
    material: "Durable Ceramic with High-Fire Enamel",
    dimensions: "Cup Capacity: 70ml (12 cups + 12 saucers)",
    cultural_significance: "Accommodates all guests so that everyone sips the Baraka round together in unison.",
    usage_instructions: "Dishwasher safe on gentle cycle.",
    image_url: "/images/products/cini-set-floral.jpg"
  },
  {
    category: categories[:serving],
    name: "Hand-Carved Two-Tier Wooden Rekebot Coffee Table (ረከቦት)",
    amharic_name: "ባህላዊ በእጅ የተቀረጸ የእንጨት ረከቦት",
    slug: "hand-carved-two-tier-wooden-rekebot",
    sku: "YB-SRV-REK-WOD-01",
    short_description: "Exquisite two-tiered wooden ceremony table with cup recesses and storage drawer for incense.",
    description: "Handcrafted from seasoned Wondo Genet timber by master woodcarvers. Features designated circular recesses for 12 Sini cups on the top tier, while the lower sliding drawer houses Frankincense, spices, and stirring implements.",
    price_kes: 6800.00,
    price_etb: 5984.00,
    stock_quantity: 18,
    weight_grams: 3800,
    is_featured: true,
    material: "Native Hardwood with Hand-Rubbed Beeswax Polish",
    dimensions: "Length: 48cm, Width: 32cm, Height: 24cm",
    cultural_significance: "The visual anchor of the living room ceremony. Sitting around the Rekebot signifies familial unity and mutual respect.",
    usage_instructions: "Wipe with damp cloth and nourish with natural mineral oil twice yearly.",
    image_url: "/images/products/rekebot-table.jpg"
  },
  {
    category: categories[:serving],
    name: "Luxury Embossed White & Gold Porcelain Rekebot Tray",
    amharic_name: "የወርቅ ቅብ የሸክላ ረከቦት",
    slug: "luxury-embossed-white-gold-porcelain-rekebot",
    sku: "YB-SRV-REK-PRC-02",
    short_description: "Modern elegant ceremony tray with gold leaf accents and non-slip cup placement markers.",
    description: "A contemporary interpretation of the ceremony tray popular in Addis Ababa hotels and upscale modern residences.",
    price_kes: 5400.00,
    price_etb: 4752.00,
    stock_quantity: 22,
    weight_grams: 2800,
    is_featured: false,
    material: "Reinforced Enamelled Porcelain",
    dimensions: "Length: 44cm, Width: 30cm",
    cultural_significance: "Bridges centuries-old coffee rituals with high-end contemporary interior spaces.",
    usage_instructions: "Handle with care. Avoid abrasive cleaning pads.",
    image_url: "/images/products/rekebot-porcelain-tray.jpg"
  },
  {
    category: categories[:serving],
    name: "Artisan Olive Wood Coffee Stirring Rods (ማሼሻ / Mashesha) - Pair",
    amharic_name: "የወይራ እንጨት ማሼሻ (2 ቁራጭ)",
    slug: "artisan-olive-wood-stirring-rods-pair",
    sku: "YB-SRV-MSH-01",
    short_description: "Turned natural African olive wood rods for stirring sugar, honey, and rue inside the Jebena.",
    description: "Crafted from wild dense olive wood grain with a smooth polished tip that will not scratch the inner clay lining of your Jebena pot.",
    price_kes: 750.00,
    price_etb: 660.00,
    stock_quantity: 80,
    weight_grams: 120,
    is_featured: false,
    material: "East African Wild Olive Wood",
    dimensions: "Length: 22cm",
    cultural_significance: "Used during the brewing process to gently awaken grounds settled in the lower chamber.",
    usage_instructions: "Hand wash with cold water; dry immediately.",
    image_url: "/images/products/mashesha-stirrer.jpg"
  }
]

serving_ware.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Serving Ware (Sini sets, Rekebot tables, Olive Wood Mashesha)."

# 6. Product Seeding: Category 4 - Modern & Traditional Milling
milling_hardware = [
  {
    category: categories[:milling],
    name: "Heavy Cast-Iron Traditional Hand Mill (Manual Buna Grinder)",
    amharic_name: "የብረት እጅ መፍጫ",
    slug: "heavy-cast-iron-traditional-hand-mill",
    sku: "YB-MIL-MAN-01",
    short_description: "Clamp-mount cast iron manual mill calibrated for ultra-fine powdery Jebena grind.",
    description: "Built like a tank with hardened steel burrs that reduce dark roasted beans to an almost microscopic powder. Clamps sturdily to any kitchen countertop or table ledge.",
    price_kes: 4200.00,
    price_etb: 3696.00,
    stock_quantity: 30,
    weight_grams: 2400,
    is_featured: true,
    material: "Cast Iron Body with Hardened Steel Rotary Burrs",
    dimensions: "Height: 32cm, Hopper Capacity: 250g",
    cultural_significance: "The definitive domestic mill seen in Ethiopian households for reliable electricity-free preparation.",
    usage_instructions: "Turn adjustment dial clockwise until burrs produce powdery flour."
  },
  {
    category: categories[:milling],
    name: "Precision Conical Burr Electric Grinder (Jebena Spec)",
    amharic_name: "ዘመናዊ የኤሌክትሪክ ቡና መፍጫ",
    slug: "precision-conical-burr-electric-grinder-jebena-spec",
    sku: "YB-MIL-ELE-02",
    short_description: "Low-RPM 40mm stainless steel conical burr grinder with dedicated 'Buna Jebena' micro-stepped setting.",
    description: "Combines modern low-heat grinding technology with the specialized fine grind requirements of traditional infusion brewing. Preserves delicate floral aromatics of Yirgacheffe and Sidamo beans.",
    price_kes: 9800.00,
    price_etb: 8624.00,
    stock_quantity: 15,
    weight_grams: 2200,
    is_featured: false,
    material: "Brushed Aluminum Housing with Italian Stainless Burrs",
    dimensions: "220V Kenya/UK 3-Pin Plug, 150W Motor",
    cultural_significance: "Designed for busy Kenyan professionals who cherish authentic Buna taste with modern morning speed.",
    usage_instructions: "Set dial to Level 1-2 for clay Jebena decoction."
  },
  {
    category: categories[:milling],
    name: "Handcrafted Brass Cylindrical Travel Grinder",
    amharic_name: "የኪስ ናስ መፍጫ",
    slug: "handcrafted-brass-cylindrical-travel-grinder",
    sku: "YB-MIL-BRS-03",
    short_description: "Compact brass pocket grinder with folding handle and stepless grind collar.",
    description: "An elegant, portable milling tool ideal for grinding small single-pot batches while traveling.",
    price_kes: 3500.00,
    price_etb: 3080.00,
    stock_quantity: 25,
    weight_grams: 650,
    is_featured: false,
    material: "Engraved Solid Brass",
    dimensions: "Height: 18cm, Diameter: 4.5cm",
    cultural_significance: "A timeless artifact popular along the ancient caravan trading routes.",
    usage_instructions: "Disassemble base cup to collect freshly ground coffee."
  }
]

milling_hardware.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Modern & Traditional Milling Equipment."

# 7. Product Seeding: Category 5 - Sensory & Mood Enhancers (Incense, Frankincense, Myrrh, Tenadam, Spices)
sensory_products = [
  {
    category: categories[:sensory],
    name: "Royal Tigray Frankincense (Olibanum / Etan / ዕጣን) - Grade 1",
    amharic_name: "የሮያል ትግራይ ነጭ ዕጣን (አንደኛ ደረጃ)",
    slug: "royal-tigray-frankincense-grade-1",
    sku: "YB-SNS-FTN-TIG-01",
    short_description: "Pure golden tear resins of Boswellia papyrifera harvested from northern Ethiopian highlands.",
    description: "The aromatic soul of the coffee ceremony. When placed upon hot charcoal, these translucent amber tears release a citrusy, balsamic, ethereal smoke that sanctifies the room.",
    price_kes: 950.00,
    price_etb: 836.00,
    stock_quantity: 120,
    weight_grams: 250,
    is_featured: true,
    material: "100% Pure Natural Boswellia Papyrifera Resin",
    cultural_significance: "Casting Etan upon the coals drives away discord and fills the home with peaceful celestial scent during all three rounds of Buna.",
    usage_instructions: "Place one or two tears directly on glowing charcoal in the Gidich burner."
  },
  {
    category: categories[:sensory],
    name: "Traditional Handcrafted Clay Incense Burner (Gidich / Mubakhar)",
    amharic_name: "የሸክላ ዕጣን ማፋጫ (ግድች)",
    slug: "traditional-handcrafted-clay-incense-burner-gidich",
    sku: "YB-SNS-BRN-CLY-01",
    short_description: "Earthen terracotta brazier with pierced dome lid and carved cross patterns.",
    description: "Small portable clay vessel with insulated base designed to safely hold a single lump of burning charcoal for burning Frankincense and Myrrh throughout the ceremony.",
    price_kes: 1400.00,
    price_etb: 1232.00,
    stock_quantity: 45,
    weight_grams: 600,
    is_featured: true,
    material: "High-Fired Terracotta Clay",
    dimensions: "Height: 14cm, Base Diameter: 11cm",
    cultural_significance: "Walked around the room and placed beneath the Rekebot table to envelop guests in aromatic smoke.",
    usage_instructions: "Add a layer of sand at the base before lighting charcoal to protect surface."
  },
  {
    category: categories[:sensory],
    name: "Pure Ogaden Myrrh Resin Tears (Karbe / ከርቤ)",
    amharic_name: "የኦጋዴን ንጹህ ከርቤ ዕጣን",
    slug: "pure-ogaden-myrrh-resin-tears-karbe",
    sku: "YB-SNS-MYR-OGA-01",
    short_description: "Deep reddish-brown Commiphora myrrha tears with an earthy, warm, grounding scent.",
    description: "Harvested from wild desert trees in eastern Ethiopia, prized for deep therapeutic properties and rich meditative aroma when burned alongside Frankincense.",
    price_kes: 1100.00,
    price_etb: 968.00,
    stock_quantity: 65,
    weight_grams: 200,
    is_featured: false,
    material: "100% Pure Wild Commiphora Myrrha",
    cultural_significance: "Burned during solemn blessings and ceremonial Baraka prayers.",
    usage_instructions: "Blend with Frankincense tears in a 1:2 ratio on charcoal."
  },
  {
    category: categories[:sensory],
    name: "Fresh Ethiopian Rue Herbs (Tenadam / ጤናዳም) - Cuttings & Seeds",
    amharic_name: "የጤናዳም ቅጠል (የቡና ቅመም)",
    slug: "fresh-ethiopian-rue-herbs-tenadam",
    sku: "YB-SNS-TEN-HRB-01",
    short_description: "Freshly air-dried stems of Ruta chalepensis used to stir and infuse individual coffee cups.",
    description: "Tenadam ('Health of Adam') is the signature herbaceous aroma of the traditional cup. A small sprig is dipped into the piping hot Sini cup just before drinking, imparting a bright citrusy, eucalyptus sweetness.",
    price_kes: 650.00,
    price_etb: 572.00,
    stock_quantity: 90,
    weight_grams: 100,
    is_featured: true,
    material: "Organically Grown Air-Dried Ruta Chalepensis Stems",
    cultural_significance: "Believed to aid digestion and balance the rich oils of dark roast coffee. An indispensable part of genuine Ethiopian Buna hospitality.",
    usage_instructions: "Dip one sprig into your hot cup of black Buna for 10-15 seconds, remove and enjoy."
  },
  {
    category: categories[:sensory],
    name: "Ceremonial Buna Korerima Spice Infusion Blend",
    amharic_name: "የቡና ኮረሪማ እና የቅመም ድብልቅ",
    slug: "ceremonial-buna-korerima-spice-infusion",
    sku: "YB-SNS-KOR-SPC-01",
    short_description: "Artisan blend of Ethiopian black cardamom (Korerima), dried ginger, and mountain cloves.",
    description: "Ground together in small batches to sprinkle into the Jebena neck during the boil, creating a comforting spiced coffee tradition popular in northern highlands.",
    price_kes: 850.00,
    price_etb: 748.00,
    stock_quantity: 85,
    weight_grams: 150,
    is_featured: false,
    material: "Wild Ethiopian Black Cardamom, Sun-Dried Ginger, Cloves",
    cultural_significance: "Customarily offered to nursing mothers, honored elders, and during cold highland evenings.",
    usage_instructions: "Add 1/4 teaspoon into the Jebena grounds before adding water."
  },
  {
    category: categories[:sensory],
    name: "Aromatic Wild Olive Wood Shavings & Natural Coconut Coals",
    amharic_name: "የወይራ እንጨት ቅርፊት እና ከሰል",
    slug: "aromatic-wild-olive-wood-shavings-coals",
    sku: "YB-SNS-WOD-CHL-01",
    short_description: "Sweet-scented dried olive wood chips paired with smokeless coconut shell charcoal tabs.",
    description: "Provides the authentic woodsy aroma of traditional village coffee huts without overwhelming indoor living spaces.",
    price_kes: 700.00,
    price_etb: 616.00,
    stock_quantity: 75,
    weight_grams: 500,
    is_featured: false,
    material: "Pruned Wild Olive Wood & Carbonized Coconut Shell",
    cultural_significance: "Evokes the comforting fragrance of the Ethiopian hearth.",
    usage_instructions: "Light charcoal tab, wait 3 minutes until white ash forms, then add wood chips."
  }
]

sensory_products.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Sensory & Mood Enhancers (Tigray Frankincense, Gidich, Tenadam, Korerima)."

# 8. Product Seeding: Category 6 - Spatial Aesthetics & Decor (Mats, Tibeb Runners, Stools)
decor_products = [
  {
    category: categories[:decor],
    name: "Handwoven Ketema Ceremonial Floor Mat (ቄጠማ)",
    amharic_name: "ባህላዊ የቄጠማ ምንጣፍ",
    slug: "handwoven-ketema-ceremonial-floor-mat",
    sku: "YB-DEC-MAT-KET-01",
    short_description: "Braided natural river reed mat designed to serve as an elegant indoor substitute for freshly cut grass.",
    description: "In Ethiopia, green grass is scattered across the floor to welcome guests. This tight-braided, sustainably harvested reed mat captures the aesthetic freshness while keeping modern Kenyan apartments clean and immaculate.",
    price_kes: 2400.00,
    price_etb: 2112.00,
    stock_quantity: 40,
    weight_grams: 1100,
    is_featured: true,
    material: "100% Natural Braided Sedge Reed with Green Edge Binding",
    dimensions: "180cm x 120cm (Full Area Mat)",
    cultural_significance: "Grass and Ketema symbolize life, fertility, peace, and renewal of hospitality.",
    usage_instructions: "Unroll beneath the Rekebot table and stools. Shake out after ceremony."
  },
  {
    category: categories[:decor],
    name: "Native Hand-Embroidered Tibeb Table Runner (ጥበብ)",
    amharic_name: "በእጅ የተጠለፈ የጥበብ ጠረጴዛ ልብስ",
    slug: "native-hand-embroidered-tibeb-table-runner",
    sku: "YB-DEC-RUN-TIB-01",
    short_description: "Pure Ethiopian Shemane hand-spun cotton runner with intricate multicolored geometric cross borders.",
    description: "Woven by traditional weavers (Shemane) on pit looms in Addis Ababa using unbleached highland cotton and lustrous metallic gold thread embroidery.",
    price_kes: 2800.00,
    price_etb: 2464.00,
    stock_quantity: 35,
    weight_grams: 350,
    is_featured: true,
    material: "100% Hand-Spun Ethiopian Cotton with Gold & Silk Embroidery",
    dimensions: "Length: 160cm, Width: 40cm",
    cultural_significance: "Tibeb patterns convey regional Horn of Africa identity and celebrate centuries of loom artistry.",
    usage_instructions: "Hand wash cold; iron with low steam."
  },
  {
    category: categories[:decor],
    name: "Traditional Handcrafted Wooden Barchuma Stool (በርጩማ)",
    amharic_name: "የወንዶ ገነት ባህላዊ በርጩማ",
    slug: "traditional-handcrafted-wooden-barchuma-stool",
    sku: "YB-DEC-STL-BAR-01",
    short_description: "Low-slung three-legged carved stool made from solid Wondo Genet timber.",
    description: "Ergonomically shaped seat with hand-gouged tribal carvings. The host sits low upon the Barchuma near the charcoal brazier to tend the Jebena and pour the Sini cups gracefully.",
    price_kes: 3600.00,
    price_etb: 3168.00,
    stock_quantity: 20,
    weight_grams: 2800,
    is_featured: false,
    material: "Solid One-Piece Carved Native Hardwood",
    dimensions: "Height: 28cm, Seat Diameter: 30cm",
    cultural_significance: "Puts the ceremony leader at eye level with the clay pot and seated guests, fostering community intimacy.",
    usage_instructions: "Suitable for indoor or covered patio ceremony lounges."
  },
  {
    category: categories[:decor],
    name: "Embroidered Velvet Buna Floor Cushion / Pouf",
    amharic_name: "የቡና ማስተናገጃ የቬልቬት ትራስ",
    slug: "embroidered-velvet-buna-floor-cushion",
    sku: "YB-DEC-CSH-VLV-01",
    short_description: "Plush circular floor cushion with golden fringe and Ethiopian Orthodox cross motifs.",
    description: "Provides relaxed, luxurious floor seating for family and visitors during prolonged 3-round gatherings.",
    price_kes: 2200.00,
    price_etb: 1936.00,
    stock_quantity: 30,
    weight_grams: 1400,
    is_featured: false,
    material: "Deep Burgundy Velvet with Gold Cord Trimming",
    dimensions: "Diameter: 45cm, Thickness: 15cm",
    cultural_significance: "Invites guests to slow down and stay for the Baraka blessing.",
    usage_instructions: "Spot clean with gentle fabric cleaner."
  }
]

decor_products.each do |data|
  Product.create!(data)
end
puts "✓ Seeded Spatial Aesthetics & Decor (Ketema Mats, Tibeb Runners, Barchuma Stools)."

puts "=========================================================================="
puts "YEBENTE BUNA DATABASE SEEDING COMPLETED SUCCESSFULLY!"
puts "Total Products: #{Product.count} across 6 ceremonial categories."
puts "Merchant Phone: #{ENV.fetch('DEFAULT_MERCHANT_PHONE', '+254707172370')}"
puts "Admin Email: #{admin_user.email}"
puts "=========================================================================="
