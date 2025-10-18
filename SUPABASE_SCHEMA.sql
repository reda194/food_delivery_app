-- =====================================================
-- FOOD DELIVERY APP - COMPLETE DATABASE SCHEMA
-- =====================================================
-- Version: 1.0.0
-- Created: 2025-01-18
-- Database: PostgreSQL (Supabase)
--
-- INSTRUCTIONS:
-- 1. Copy this entire file
-- 2. Go to Supabase Dashboard → SQL Editor
-- 3. Create "New Query"
-- 4. Paste this content
-- 5. Click "Run"
-- 6. Wait for "Success" message
-- =====================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLE: USERS
-- Stores user profile information
-- =====================================================
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  phone_number TEXT,
  profile_image TEXT,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,
  email_verified BOOLEAN DEFAULT false,
  phone_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  last_login_at TIMESTAMP WITH TIME ZONE,

  -- Constraints
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
  CONSTRAINT valid_phone CHECK (phone_number IS NULL OR phone_number ~ '^\+?[0-9]{10,15}$')
);

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_phone ON public.users(phone_number);
CREATE INDEX IF NOT EXISTS idx_users_active ON public.users(is_active) WHERE is_active = true;

-- =====================================================
-- TABLE: CATEGORIES
-- Food categories (Pizza, Burgers, etc.)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.categories (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL UNIQUE,
  description TEXT,
  icon TEXT,
  image_url TEXT,
  color_code TEXT DEFAULT '#FF6B35',
  display_order INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_color CHECK (color_code ~ '^#[0-9A-Fa-f]{6}$')
);

CREATE INDEX IF NOT EXISTS idx_categories_active ON public.categories(is_active, display_order);

-- =====================================================
-- TABLE: RESTAURANTS
-- Restaurant information and metadata
-- =====================================================
CREATE TABLE IF NOT EXISTS public.restaurants (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT,
  image_url TEXT,
  cover_image_url TEXT,
  logo_url TEXT,

  -- Cuisine and classification
  cuisine_type TEXT[] DEFAULT ARRAY[]::TEXT[],
  tags TEXT[] DEFAULT ARRAY[]::TEXT[],

  -- Ratings and reviews
  rating DECIMAL(3,2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  total_reviews INTEGER DEFAULT 0,
  total_orders INTEGER DEFAULT 0,

  -- Delivery information
  delivery_time_min INTEGER DEFAULT 30,
  delivery_time_max INTEGER DEFAULT 45,
  delivery_fee DECIMAL(10,2) DEFAULT 2.99,
  min_order_amount DECIMAL(10,2) DEFAULT 10.00,
  max_delivery_distance DECIMAL(10,2) DEFAULT 10.0, -- in km

  -- Location
  address TEXT NOT NULL,
  city TEXT,
  state TEXT,
  zip_code TEXT,
  country TEXT DEFAULT 'USA',
  latitude DECIMAL(10,8),
  longitude DECIMAL(11,8),

  -- Operating status
  is_open BOOLEAN DEFAULT true,
  is_accepting_orders BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  is_verified BOOLEAN DEFAULT false,

  -- Contact
  phone_number TEXT,
  email TEXT,
  website TEXT,

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_rating CHECK (rating >= 0 AND rating <= 5),
  CONSTRAINT valid_delivery_time CHECK (delivery_time_min <= delivery_time_max),
  CONSTRAINT valid_coordinates CHECK (
    (latitude IS NULL AND longitude IS NULL) OR
    (latitude BETWEEN -90 AND 90 AND longitude BETWEEN -180 AND 180)
  )
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_restaurants_location ON public.restaurants(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_restaurants_rating ON public.restaurants(rating DESC);
CREATE INDEX IF NOT EXISTS idx_restaurants_open ON public.restaurants(is_open, is_accepting_orders);
CREATE INDEX IF NOT EXISTS idx_restaurants_featured ON public.restaurants(is_featured) WHERE is_featured = true;
CREATE INDEX IF NOT EXISTS idx_restaurants_cuisine ON public.restaurants USING GIN(cuisine_type);

-- =====================================================
-- TABLE: RESTAURANT_HOURS
-- Operating hours for restaurants
-- =====================================================
CREATE TABLE IF NOT EXISTS public.restaurant_hours (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  day_of_week INTEGER NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Sunday, 6=Saturday
  open_time TIME NOT NULL,
  close_time TIME NOT NULL,
  is_closed BOOLEAN DEFAULT false,

  UNIQUE(restaurant_id, day_of_week)
);

CREATE INDEX IF NOT EXISTS idx_restaurant_hours_restaurant ON public.restaurant_hours(restaurant_id);

-- =====================================================
-- TABLE: MENU_ITEMS
-- Food items available for order
-- =====================================================
CREATE TABLE IF NOT EXISTS public.menu_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  category_id UUID REFERENCES public.categories(id) ON DELETE SET NULL,

  -- Basic info
  name TEXT NOT NULL,
  slug TEXT NOT NULL,
  description TEXT,
  image_url TEXT,

  -- Pricing
  price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
  original_price DECIMAL(10,2), -- For discounts
  discount_percentage INTEGER DEFAULT 0 CHECK (discount_percentage BETWEEN 0 AND 100),

  -- Availability and status
  is_available BOOLEAN DEFAULT true,
  is_featured BOOLEAN DEFAULT false,
  stock_quantity INTEGER, -- NULL = unlimited

  -- Dietary information
  is_vegetarian BOOLEAN DEFAULT false,
  is_vegan BOOLEAN DEFAULT false,
  is_gluten_free BOOLEAN DEFAULT false,
  is_spicy BOOLEAN DEFAULT false,
  spice_level INTEGER DEFAULT 0 CHECK (spice_level BETWEEN 0 AND 5),

  -- Additional info
  calories INTEGER,
  prep_time INTEGER, -- in minutes
  serving_size TEXT,
  allergens TEXT[],
  ingredients TEXT[],

  -- Ratings
  rating DECIMAL(3,2) DEFAULT 0 CHECK (rating >= 0 AND rating <= 5),
  total_reviews INTEGER DEFAULT 0,
  total_orders INTEGER DEFAULT 0,

  -- Timestamps
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Constraints
  UNIQUE(restaurant_id, slug),
  CONSTRAINT valid_discount CHECK (
    discount_percentage = 0 OR
    (original_price IS NOT NULL AND original_price > price)
  )
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_menu_items_restaurant ON public.menu_items(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON public.menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_available ON public.menu_items(is_available) WHERE is_available = true;
CREATE INDEX IF NOT EXISTS idx_menu_items_featured ON public.menu_items(is_featured) WHERE is_featured = true;
CREATE INDEX IF NOT EXISTS idx_menu_items_price ON public.menu_items(price);
CREATE INDEX IF NOT EXISTS idx_menu_items_rating ON public.menu_items(rating DESC);

-- =====================================================
-- TABLE: ADDRESSES
-- User delivery addresses
-- =====================================================
CREATE TABLE IF NOT EXISTS public.addresses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Address details
  label TEXT NOT NULL, -- 'Home', 'Office', etc.
  full_address TEXT NOT NULL,
  apartment_suite TEXT,
  street_address TEXT NOT NULL,
  city TEXT NOT NULL,
  state TEXT NOT NULL,
  zip_code TEXT NOT NULL,
  country TEXT DEFAULT 'USA',

  -- Location
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,

  -- Contact
  recipient_name TEXT,
  recipient_phone TEXT,

  -- Delivery instructions
  delivery_instructions TEXT,

  -- Status
  is_default BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT valid_coordinates CHECK (
    latitude BETWEEN -90 AND 90 AND
    longitude BETWEEN -180 AND 180
  )
);

CREATE INDEX IF NOT EXISTS idx_addresses_user ON public.addresses(user_id);
CREATE INDEX IF NOT EXISTS idx_addresses_default ON public.addresses(user_id, is_default) WHERE is_default = true;

-- =====================================================
-- TABLE: PAYMENT_METHODS
-- Saved payment methods
-- =====================================================
CREATE TABLE IF NOT EXISTS public.payment_methods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Payment type: 'card', 'paypal', 'apple_pay', 'google_pay', 'cash'
  payment_type TEXT NOT NULL CHECK (payment_type IN ('card', 'paypal', 'apple_pay', 'google_pay', 'cash')),

  -- Card details (encrypted in production)
  card_brand TEXT, -- 'visa', 'mastercard', 'amex', etc.
  card_last_four TEXT,
  card_expiry_month INTEGER CHECK (card_expiry_month BETWEEN 1 AND 12),
  card_expiry_year INTEGER,
  cardholder_name TEXT,

  -- Payment provider token (Stripe, PayPal, etc.)
  provider_token TEXT,
  provider_customer_id TEXT,

  -- Billing address
  billing_address_id UUID REFERENCES public.addresses(id) ON DELETE SET NULL,

  -- Status
  is_default BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  is_verified BOOLEAN DEFAULT false,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_payment_methods_user ON public.payment_methods(user_id);
CREATE INDEX IF NOT EXISTS idx_payment_methods_default ON public.payment_methods(user_id, is_default) WHERE is_default = true;

-- =====================================================
-- TABLE: PROMO_CODES
-- Discount and promo codes
-- =====================================================
CREATE TABLE IF NOT EXISTS public.promo_codes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code TEXT UNIQUE NOT NULL,
  description TEXT,

  -- Discount details
  discount_type TEXT NOT NULL CHECK (discount_type IN ('percentage', 'fixed_amount', 'free_delivery')),
  discount_value DECIMAL(10,2) NOT NULL CHECK (discount_value >= 0),
  max_discount_amount DECIMAL(10,2), -- For percentage discounts
  min_order_amount DECIMAL(10,2) DEFAULT 0,

  -- Usage limits
  max_uses INTEGER, -- NULL = unlimited
  max_uses_per_user INTEGER DEFAULT 1,
  current_uses INTEGER DEFAULT 0,

  -- Validity
  valid_from TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  valid_until TIMESTAMP WITH TIME ZONE,

  -- Restrictions
  applicable_restaurants UUID[], -- NULL = all restaurants
  applicable_categories UUID[], -- NULL = all categories
  first_order_only BOOLEAN DEFAULT false,

  -- Status
  is_active BOOLEAN DEFAULT true,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT valid_discount_value CHECK (
    (discount_type = 'percentage' AND discount_value BETWEEN 0 AND 100) OR
    (discount_type != 'percentage' AND discount_value >= 0)
  )
);

CREATE INDEX IF NOT EXISTS idx_promo_codes_code ON public.promo_codes(code);
CREATE INDEX IF NOT EXISTS idx_promo_codes_active ON public.promo_codes(is_active, valid_from, valid_until);

-- =====================================================
-- TABLE: ORDERS
-- Customer orders
-- =====================================================
CREATE TABLE IF NOT EXISTS public.orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_number TEXT UNIQUE NOT NULL, -- e.g., 'ORD-20250118-001'

  -- User and restaurant
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE SET NULL,

  -- Order status
  status TEXT NOT NULL DEFAULT 'pending' CHECK (
    status IN ('pending', 'confirmed', 'preparing', 'ready', 'picked_up',
               'on_the_way', 'delivered', 'cancelled', 'refunded')
  ),

  -- Pricing
  subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
  delivery_fee DECIMAL(10,2) NOT NULL CHECK (delivery_fee >= 0),
  tax DECIMAL(10,2) NOT NULL CHECK (tax >= 0),
  service_fee DECIMAL(10,2) DEFAULT 0 CHECK (service_fee >= 0),
  discount DECIMAL(10,2) DEFAULT 0 CHECK (discount >= 0),
  tip DECIMAL(10,2) DEFAULT 0 CHECK (tip >= 0),
  total DECIMAL(10,2) NOT NULL CHECK (total >= 0),

  -- Promo code
  promo_code_id UUID REFERENCES public.promo_codes(id) ON DELETE SET NULL,
  promo_code_used TEXT,

  -- Delivery information
  delivery_address JSONB NOT NULL,
  delivery_latitude DECIMAL(10,8),
  delivery_longitude DECIMAL(11,8),
  delivery_instructions TEXT,
  estimated_delivery_time TIMESTAMP WITH TIME ZONE,
  actual_delivery_time TIMESTAMP WITH TIME ZONE,

  -- Payment information
  payment_method JSONB NOT NULL,
  payment_status TEXT DEFAULT 'pending' CHECK (
    payment_status IN ('pending', 'processing', 'completed', 'failed', 'refunded')
  ),
  payment_intent_id TEXT, -- Stripe payment intent
  transaction_id TEXT,

  -- Driver information
  driver_id UUID, -- Would reference drivers table
  driver_name TEXT,
  driver_phone TEXT,
  driver_latitude DECIMAL(10,8),
  driver_longitude DECIMAL(11,8),

  -- Special requirements
  special_instructions TEXT,
  contactless_delivery BOOLEAN DEFAULT false,

  -- Ratings and feedback
  user_rating INTEGER CHECK (user_rating BETWEEN 1 AND 5),
  user_review TEXT,
  restaurant_rating INTEGER CHECK (restaurant_rating BETWEEN 1 AND 5),

  -- Timestamps
  placed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  confirmed_at TIMESTAMP WITH TIME ZONE,
  preparing_at TIMESTAMP WITH TIME ZONE,
  ready_at TIMESTAMP WITH TIME ZONE,
  picked_up_at TIMESTAMP WITH TIME ZONE,
  delivered_at TIMESTAMP WITH TIME ZONE,
  cancelled_at TIMESTAMP WITH TIME ZONE,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT valid_total CHECK (total = subtotal + delivery_fee + tax + service_fee + tip - discount)
);

-- Generate order number automatically
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
  NEW.order_number := 'ORD-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' ||
                      LPAD(NEXTVAL('order_number_seq')::TEXT, 6, '0');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE SEQUENCE IF NOT EXISTS order_number_seq START 1;

CREATE TRIGGER set_order_number
  BEFORE INSERT ON public.orders
  FOR EACH ROW
  WHEN (NEW.order_number IS NULL)
  EXECUTE FUNCTION generate_order_number();

-- Indexes
CREATE INDEX IF NOT EXISTS idx_orders_user ON public.orders(user_id);
CREATE INDEX IF NOT EXISTS idx_orders_restaurant ON public.orders(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON public.orders(status);
CREATE INDEX IF NOT EXISTS idx_orders_created ON public.orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_number ON public.orders(order_number);

-- =====================================================
-- TABLE: ORDER_ITEMS
-- Individual items in an order
-- =====================================================
CREATE TABLE IF NOT EXISTS public.order_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id UUID REFERENCES public.orders(id) ON DELETE CASCADE,
  menu_item_id UUID REFERENCES public.menu_items(id) ON DELETE SET NULL,

  -- Item details (snapshot at time of order)
  item_name TEXT NOT NULL,
  item_description TEXT,
  item_image_url TEXT,

  -- Pricing
  unit_price DECIMAL(10,2) NOT NULL CHECK (unit_price >= 0),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),

  -- Customizations
  customizations JSONB DEFAULT '[]'::JSONB,
  special_instructions TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  CONSTRAINT valid_subtotal CHECK (subtotal = unit_price * quantity)
);

CREATE INDEX IF NOT EXISTS idx_order_items_order ON public.order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_menu_item ON public.order_items(menu_item_id);

-- =====================================================
-- TABLE: FAVORITES
-- User's favorite restaurants and menu items
-- =====================================================
CREATE TABLE IF NOT EXISTS public.favorites (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Can favorite either restaurant or menu item
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  menu_item_id UUID REFERENCES public.menu_items(id) ON DELETE CASCADE,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Ensure only one of restaurant_id or menu_item_id is set
  CONSTRAINT check_favorite_type CHECK (
    (restaurant_id IS NOT NULL AND menu_item_id IS NULL) OR
    (restaurant_id IS NULL AND menu_item_id IS NOT NULL)
  ),

  -- Prevent duplicate favorites
  UNIQUE(user_id, restaurant_id),
  UNIQUE(user_id, menu_item_id)
);

CREATE INDEX IF NOT EXISTS idx_favorites_user ON public.favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_restaurant ON public.favorites(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_favorites_menu_item ON public.favorites(menu_item_id);

-- =====================================================
-- TABLE: REVIEWS
-- User reviews for restaurants
-- =====================================================
CREATE TABLE IF NOT EXISTS public.reviews (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,

  -- Review content
  rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  title TEXT,
  comment TEXT,

  -- Specific ratings
  food_rating INTEGER CHECK (food_rating BETWEEN 1 AND 5),
  service_rating INTEGER CHECK (service_rating BETWEEN 1 AND 5),
  delivery_rating INTEGER CHECK (delivery_rating BETWEEN 1 AND 5),

  -- Images
  images TEXT[],

  -- Helpful votes
  helpful_count INTEGER DEFAULT 0,

  -- Response from restaurant
  restaurant_response TEXT,
  restaurant_responded_at TIMESTAMP WITH TIME ZONE,

  -- Status
  is_verified_purchase BOOLEAN DEFAULT false,
  is_visible BOOLEAN DEFAULT true,
  is_flagged BOOLEAN DEFAULT false,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- One review per user per order
  UNIQUE(user_id, order_id)
);

CREATE INDEX IF NOT EXISTS idx_reviews_restaurant ON public.reviews(restaurant_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON public.reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON public.reviews(rating DESC);
CREATE INDEX IF NOT EXISTS idx_reviews_created ON public.reviews(created_at DESC);

-- =====================================================
-- TABLE: NOTIFICATIONS
-- User notifications
-- =====================================================
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,

  -- Notification content
  title TEXT NOT NULL,
  message TEXT NOT NULL,

  -- Type: 'order', 'promo', 'system', 'review'
  type TEXT NOT NULL CHECK (type IN ('order', 'promo', 'system', 'review', 'delivery')),

  -- Related data
  data JSONB DEFAULT '{}'::JSONB,
  order_id UUID REFERENCES public.orders(id) ON DELETE SET NULL,

  -- Delivery
  is_push_sent BOOLEAN DEFAULT false,
  is_email_sent BOOLEAN DEFAULT false,
  is_sms_sent BOOLEAN DEFAULT false,

  -- Status
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP WITH TIME ZONE,

  -- Action
  action_url TEXT,
  action_label TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX IF NOT EXISTS idx_notifications_user ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_unread ON public.notifications(user_id, is_read) WHERE is_read = false;
CREATE INDEX IF NOT EXISTS idx_notifications_created ON public.notifications(created_at DESC);

-- =====================================================
-- TABLE: CART
-- User shopping cart (persistent)
-- =====================================================
CREATE TABLE IF NOT EXISTS public.cart (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  restaurant_id UUID REFERENCES public.restaurants(id) ON DELETE CASCADE,

  -- Cart metadata
  subtotal DECIMAL(10,2) DEFAULT 0,
  item_count INTEGER DEFAULT 0,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cart_user ON public.cart(user_id);

-- =====================================================
-- TABLE: CART_ITEMS
-- Items in user's cart
-- =====================================================
CREATE TABLE IF NOT EXISTS public.cart_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  cart_id UUID REFERENCES public.cart(id) ON DELETE CASCADE,
  menu_item_id UUID REFERENCES public.menu_items(id) ON DELETE CASCADE,

  quantity INTEGER NOT NULL CHECK (quantity > 0),
  customizations JSONB DEFAULT '[]'::JSONB,
  special_instructions TEXT,

  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  UNIQUE(cart_id, menu_item_id, customizations)
);

CREATE INDEX IF NOT EXISTS idx_cart_items_cart ON public.cart_items(cart_id);

-- =====================================================
-- FUNCTIONS & TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply to all tables with updated_at
DO $$
DECLARE
  t TEXT;
BEGIN
  FOR t IN
    SELECT table_name
    FROM information_schema.columns
    WHERE column_name = 'updated_at'
    AND table_schema = 'public'
  LOOP
    EXECUTE format('
      DROP TRIGGER IF EXISTS update_%I_updated_at ON public.%I;
      CREATE TRIGGER update_%I_updated_at
        BEFORE UPDATE ON public.%I
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();
    ', t, t, t, t);
  END LOOP;
END;
$$;

-- Function to create user profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, full_name, email_verified)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(
      NEW.raw_user_meta_data->>'full_name',
      NEW.raw_user_meta_data->>'name',
      SPLIT_PART(NEW.email, '@', 1)
    ),
    NEW.email_confirmed_at IS NOT NULL
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create user profile
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- Function to update restaurant rating
CREATE OR REPLACE FUNCTION update_restaurant_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.restaurants
  SET
    rating = (
      SELECT COALESCE(AVG(rating), 0)
      FROM public.reviews
      WHERE restaurant_id = NEW.restaurant_id AND is_visible = true
    ),
    total_reviews = (
      SELECT COUNT(*)
      FROM public.reviews
      WHERE restaurant_id = NEW.restaurant_id AND is_visible = true
    )
  WHERE id = NEW.restaurant_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_restaurant_rating_trigger ON public.reviews;
CREATE TRIGGER update_restaurant_rating_trigger
  AFTER INSERT OR UPDATE ON public.reviews
  FOR EACH ROW
  EXECUTE FUNCTION update_restaurant_rating();

-- Function to update menu item rating
CREATE OR REPLACE FUNCTION update_menu_item_orders()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.menu_items
  SET total_orders = total_orders + NEW.quantity
  WHERE id = NEW.menu_item_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_menu_item_orders_trigger ON public.order_items;
CREATE TRIGGER update_menu_item_orders_trigger
  AFTER INSERT ON public.order_items
  FOR EACH ROW
  EXECUTE FUNCTION update_menu_item_orders();

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurants ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.restaurant_hours ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.promo_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.cart_items ENABLE ROW LEVEL SECURITY;

-- USERS table policies
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- CATEGORIES - public read
CREATE POLICY "Anyone can view categories" ON public.categories
  FOR SELECT TO authenticated USING (is_active = true);

-- RESTAURANTS - public read
CREATE POLICY "Anyone can view restaurants" ON public.restaurants
  FOR SELECT TO authenticated USING (true);

-- RESTAURANT_HOURS - public read
CREATE POLICY "Anyone can view hours" ON public.restaurant_hours
  FOR SELECT TO authenticated USING (true);

-- MENU_ITEMS - public read
CREATE POLICY "Anyone can view menu items" ON public.menu_items
  FOR SELECT TO authenticated USING (is_available = true);

-- ADDRESSES - user specific
CREATE POLICY "Users can view own addresses" ON public.addresses
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own addresses" ON public.addresses
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own addresses" ON public.addresses
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own addresses" ON public.addresses
  FOR DELETE USING (auth.uid() = user_id);

-- PAYMENT_METHODS - user specific
CREATE POLICY "Users can view own payment methods" ON public.payment_methods
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own payment methods" ON public.payment_methods
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own payment methods" ON public.payment_methods
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own payment methods" ON public.payment_methods
  FOR DELETE USING (auth.uid() = user_id);

-- PROMO_CODES - public read (active only)
CREATE POLICY "Anyone can view active promo codes" ON public.promo_codes
  FOR SELECT TO authenticated USING (
    is_active = true AND
    valid_from <= NOW() AND
    (valid_until IS NULL OR valid_until >= NOW())
  );

-- ORDERS - user specific
CREATE POLICY "Users can view own orders" ON public.orders
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders" ON public.orders
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own orders" ON public.orders
  FOR UPDATE USING (auth.uid() = user_id);

-- ORDER_ITEMS - through orders
CREATE POLICY "Users can view own order items" ON public.order_items
  FOR SELECT USING (
    order_id IN (
      SELECT id FROM public.orders WHERE user_id = auth.uid()
    )
  );

CREATE POLICY "Users can create order items" ON public.order_items
  FOR INSERT WITH CHECK (
    order_id IN (
      SELECT id FROM public.orders WHERE user_id = auth.uid()
    )
  );

-- FAVORITES - user specific
CREATE POLICY "Users can manage own favorites" ON public.favorites
  FOR ALL USING (auth.uid() = user_id);

-- REVIEWS - read public, write own
CREATE POLICY "Anyone can view visible reviews" ON public.reviews
  FOR SELECT TO authenticated USING (is_visible = true);

CREATE POLICY "Users can create own reviews" ON public.reviews
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own reviews" ON public.reviews
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own reviews" ON public.reviews
  FOR DELETE USING (auth.uid() = user_id);

-- NOTIFICATIONS - user specific
CREATE POLICY "Users can view own notifications" ON public.notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own notifications" ON public.notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- CART - user specific
CREATE POLICY "Users can manage own cart" ON public.cart
  FOR ALL USING (auth.uid() = user_id);

-- CART_ITEMS - through cart
CREATE POLICY "Users can manage own cart items" ON public.cart_items
  FOR ALL USING (
    cart_id IN (
      SELECT id FROM public.cart WHERE user_id = auth.uid()
    )
  );

-- =====================================================
-- INITIAL DATA (Optional - Comment out if not needed)
-- =====================================================

-- Sample Categories
INSERT INTO public.categories (name, description, icon, color_code, display_order) VALUES
('Pizza', 'Delicious pizzas with various toppings', '🍕', '#FF6B35', 1),
('Burgers', 'Juicy burgers and sandwiches', '🍔', '#F7931E', 2),
('Sushi', 'Fresh sushi and Japanese cuisine', '🍣', '#00B894', 3),
('Chinese', 'Authentic Chinese dishes', '🥡', '#E84393', 4),
('Italian', 'Classic Italian cuisine', '🍝', '#6C5CE7', 5),
('Mexican', 'Spicy Mexican favorites', '🌮', '#FDCB6E', 6),
('Desserts', 'Sweet treats and desserts', '🍰', '#FF7675', 7),
('Drinks', 'Refreshing beverages', '🥤', '#00CEC9', 8),
('Salads', 'Fresh and healthy salads', '🥗', '#55EFC4', 9),
('BBQ', 'Grilled and smoked meats', '🍖', '#D63031', 10)
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

DO $$
BEGIN
  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'FOOD DELIVERY APP DATABASE SCHEMA';
  RAISE NOTICE 'Installation Complete! ✅';
  RAISE NOTICE '=====================================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Tables Created: 15';
  RAISE NOTICE 'Indexes Created: 40+';
  RAISE NOTICE 'Triggers Created: 5';
  RAISE NOTICE 'Functions Created: 5';
  RAISE NOTICE 'RLS Policies Created: 25+';
  RAISE NOTICE 'Sample Data: 10 categories';
  RAISE NOTICE '';
  RAISE NOTICE 'Next Steps:';
  RAISE NOTICE '1. Go to Supabase Dashboard → Database → Tables';
  RAISE NOTICE '2. Verify all tables are created';
  RAISE NOTICE '3. Add sample restaurant data (optional)';
  RAISE NOTICE '4. Update app_constants.dart with your Supabase URL and key';
  RAISE NOTICE '5. Run: flutter pub get && flutter run';
  RAISE NOTICE '';
  RAISE NOTICE '=====================================================';
END $$;
