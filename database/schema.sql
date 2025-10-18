-- Food Delivery App Database Schema
-- Supabase PostgreSQL Schema with Row Level Security (RLS)

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
CREATE EXTENSION IF NOT EXISTS "earthdistance";
CREATE EXTENSION IF NOT EXISTS "cube";
CREATE EXTENSION IF NOT EXISTS "postgis";

-- ==================== ENUMS ====================

-- Order status enum
CREATE TYPE order_status AS ENUM (
    'pending',
    'confirmed', 
    'preparing',
    'ready',
    'delivering',
    'completed',
    'cancelled',
    'refunded'
);

-- Delivery status enum  
CREATE TYPE delivery_status AS ENUM (
    'pending',
    'assigned',
    'picked_up',
    'on_the_way',
    'delivered',
    'failed'
);

-- Payment status enum
CREATE TYPE payment_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed',
    'refunded'
);

-- Notification type enum
CREATE TYPE notification_type AS ENUM (
    'order_update',
    'promotion',
    'system',
    'review'
);

-- ==================== TABLES ====================

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255), -- For email/password auth
    full_name VARCHAR(100),
    phone_number VARCHAR(20),
    profile_image TEXT,
    is_active BOOLEAN DEFAULT true,
    is_verified BOOLEAN DEFAULT false,
    registration_method VARCHAR(20) DEFAULT 'email', -- email, oauth
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_login_at TIMESTAMP WITH TIME ZONE
);

-- Categories table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Restaurants table
CREATE TABLE restaurants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    address JSONB,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    rating DECIMAL(3, 2) DEFAULT 0.00,
    review_count INTEGER DEFAULT 0,
    delivery_time INTEGER, -- minutes
    delivery_fee DECIMAL(10, 2) DEFAULT 2.99,
    minimum_order DECIMAL(10, 2) DEFAULT 10.00,
    phone_number VARCHAR(20),
    website TEXT,
    opening_hours JSONB,
    is_available BOOLEAN DEFAULT true,
    is_featured BOOLEAN DEFAULT false,
    search_vector tsvector,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Restaurant categories (many-to-many)
CREATE TABLE restaurant_categories (
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    category_id UUID REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (restaurant_id, category_id)
);

-- Menu items table
CREATE TABLE menu_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id UUID, -- Menu category, not food category
    is_available BOOLEAN DEFAULT true,
    is_popular BOOLEAN DEFAULT false,
    is_recommended BOOLEAN DEFAULT false,
    ingredients TEXT[],
    allergens TEXT[],
    preparation_time INTEGER, -- minutes
    calories INTEGER,
    search_vector tsvector,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Menu item options (size, extras, etc.)
CREATE TABLE menu_item_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL, -- size, extra, sauce
    is_required BOOLEAN DEFAULT false,
    min_selections INTEGER DEFAULT 0,
    max_selections INTEGER DEFAULT 1,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Menu item option values
CREATE TABLE menu_item_option_values (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    option_id UUID REFERENCES menu_item_options(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    price_modifier DECIMAL(10, 2) DEFAULT 0.00,
    display_order INTEGER DEFAULT 0
);

-- Orders table
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_number VARCHAR(20) UNIQUE NOT NULL, -- Auto-generated
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    status order_status DEFAULT 'pending',
    items JSONB NOT NULL, -- Array of订单 items with options
    subtotal DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0.00,
    delivery_fee DECIMAL(10, 2) DEFAULT 2.99,
    service_fee DECIMAL(10, 2) DEFAULT 0.00,
    tip_amount DECIMAL(10, 2) DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_method_id UUID,
    payment_status payment_status DEFAULT 'pending',
    delivery_address JSONB NOT NULL,
    delivery_address_id UUID,
    notes TEXT,
    estimated_delivery_time TIMESTAMP WITH TIME ZONE,
    actual_delivery_time TIMESTAMP WITH TIME ZONE,
    delivery_status delivery_status DEFAULT 'pending',
    driver_id UUID, -- Delivery driver reference
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Order items (separate table for detailed tracking)
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    options JSONB, -- Selected options for this item
    special_instructions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User addresses
CREATE TABLE addresses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    label VARCHAR(50), -- Home, Work, etc.
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) DEFAULT 'US',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    is_primary BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payment methods
CREATE TABLE payment_methods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(20) NOT NULL, -- credit_card, debit_card, paypal, apple_pay
    provider VARCHAR(50) NOT NULL, -- visa, mastercard, etc.
    last_four VARCHAR(4),
    expiry_month INTEGER,
    expiry_year INTEGER,
    cardholder_name VARCHAR(100),
    is_primary BOOLEAN DEFAULT false,
    stripe_payment_method_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Reviews and ratings
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id),
    rating DECIMAL(2, 1) NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    reply TEXT, -- Restaurant response
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, restaurant_id) -- One review per user per restaurant
);

-- User favorites
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, restaurant_id, menu_item_id)
);

-- Notifications
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    body TEXT,
    data JSONB, -- Additional data like order_id, etc.
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User sessions for tracking
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    device_type VARCHAR(50),
    device_id VARCHAR(255),
    token_hash VARCHAR(255), -- Hash of JWT token
    ip_address INET,
    user_agent TEXT,
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Coupons and promotions
CREATE TABLE coupons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) UNIQUE NOT NULL,
    description TEXT,
    discount_type VARCHAR(10) NOT NULL, -- percentage, fixed
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order_amount DECIMAL(10, 2) DEFAULT 0.00,
    max_discount_amount DECIMAL(10, 2),
    max_uses INTEGER,
    used_count INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    valid_from TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    valid_until TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Coupon usage tracking
CREATE TABLE coupon_usage (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    coupon_id UUID REFERENCES coupons(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    discount_amount DECIMAL(10, 2) NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, coupon_id)
);

-- Customer support tickets
CREATE TABLE support_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    order_id UUID REFERENCES orders(id),
    subject VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'open', -- open, in_progress, resolved, closed
    priority VARCHAR(10) DEFAULT 'medium', -- low, medium, high, urgent
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Support ticket messages
CREATE TABLE support_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id UUID REFERENCES support_tickets(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id), -- null for support team
    message TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT false, -- Internal notes
    attachments TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ==================== INDEXES ====================

-- Users indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_active ON users(is_active) WHERE is_active = true;
CREATE INDEX idx_users_created_at ON users(created_at);

-- Restaurants indexes
CREATE INDEX idx restaurants_location ON restaurants USING gist(point(longitude, latitude));
CREATE INDEX idx_restaurants_rating ON restaurants(rating DESC);
CREATE INDEX idx_restaurants_available ON restaurants(is_available) WHERE is_available = true;
CREATE INDEX idx_restaurants_search ON restaurants USING gin(search_vector);
CREATE INDEX idx_restaurants_name_trgm ON restaurants USING gin(name gin_trgm_ops);

-- Menu items indexes
CREATE INDEX idx_menu_items_restaurant ON menu_items(restaurant_id);
CREATE INDEX idx_menu_items_available ON menu_items(is_available) WHERE is_available = true;
CREATE INDEX idx_menu_items_search ON menu_items USING gin(search_vector);
CREATE INDEX idx_menu_items_price ON menu_items(price);

-- Orders indexes
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_restaurant_id ON orders(restaurant_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX idx_orders_total ON orders(total_amount);

-- Notification indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id) WHERE is_read = false;

-- Favorite indexes
CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_favorites_restaurant ON favorites(restaurant_id) WHERE restaurant_id IS NOT NULL;
CREATE INDEX idx_favorites_menu_item ON favorites(menu_item_id) WHERE menu_item_id IS NOT NULL;

-- Review indexes
CREATE INDEX idx_reviews_restaurant ON reviews(restaurant_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_created_at ON reviews(created_at DESC);

-- Search vector updates
CREATE OR REPLACE FUNCTION update_restaurant_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('english', COALESCE(NEW.name, '')), 'A') ||
        setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_menu_item_search_vector()
RETURNS TRIGGER AS $$
BEGIN
    NEW.search_vector :=
        setweight(to_tsvector('english', COALESCE(NEW.name, '')), 'A') ||
        setweight(to_tsvector('english', COALESCE(NEW.description, '')), 'B') ||
        setweight(to_tsvector('english', COALESCE(array_to_string(NEW.ingredients, ' '), '')), 'C');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ==================== TRIGGERS ====================

-- Update search vectors
CREATE TRIGGER update_restaurant_search_trigger
    BEFORE INSERT OR UPDATE ON restaurants
    FOR EACH ROW EXECUTE FUNCTION update_restaurant_search_vector();

CREATE TRIGGER update_menu_item_search_trigger
    BEFORE INSERT OR UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_menu_item_search_vector();

-- Update updated_at timestamps
CREATE OR REPLACE FUNCTION set_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

CREATE TRIGGER set_restaurants_updated_at BEFORE UPDATE ON restaurants
    FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

CREATE TRIGGER set_menu_items_updated_at BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

CREATE TRIGGER set_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION set_updated_at_column();

-- Auto-generate order numbers
CREATE OR REPLACE FUNCTION generate_order_number()
RETURNS TRIGGER AS $$
BEGIN
    -- Format: FD-YYYYMMDD-XXXXX (FD for Food Delivery)
    NEW.order_number = 'FD-' || to_char(NOW(), 'YYYYMMDD') || '-' || 
                      lpad((SELECT COALESCE(MAX(CAST(SUBSTRING(order_number FROM '\d+$') AS INTEGER)), 0) + 1 FROM orders)::text, 5, '0');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_order_number_trigger
    BEFORE INSERT ON orders
    FOR EACH ROW EXECUTE FUNCTION generate_order_number();

-- Update restaurant rating when review is added
CREATE OR REPLACE FUNCTION update_restaurant_rating()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE restaurants
    SET rating = COALESCE(
        (SELECT AVG(rating) FROM reviews WHERE restaurant_id = NEW.restaurant_id AND rating >= 1 AND rating <= 5),
        0.0),
        review_count = COALESCE(
        (SELECT COUNT(*) FROM reviews WHERE restaurant_id = NEW.restaurant_id AND rating >= 1 AND rating <= 5),
        0)
    WHERE id = NEW.restaurant_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_restaurant_rating_trigger
    AFTER INSERT OR UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_restaurant_rating();

-- ==================== ROW LEVEL SECURITY (RLS) ====================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_methods ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;

-- Users table policies
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON users
    FOR INSERT WITH CHECK (auth.uid() = id);

-- Orders table policies
CREATE POLICY "Users can view own orders" ON orders
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own orders" ON orders
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own orders" ON orders
    FOR UPDATE USING (auth.uid() = user_id);

-- Addresses table policies
CREATE POLICY "Users can manage own addresses" ON addresses
    FOR ALL USING (auth.uid() = user_id);

-- Payment methods table policies
CREATE POLICY "Users can manage own payment methods" ON payment_methods
    FOR ALL USING (auth.uid() = user_id);

-- Reviews table policies
CREATE POLICY "Users can view reviews" ON reviews
    FOR SELECT USING (true); -- Public access to read reviews

CREATE POLICY "Users can insert own review" ON reviews
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own review" ON reviews
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Restaurants can reply to reviews" ON reviews
    FOR UPDATE USING (
        EXISTS (
            SELECT 1 FROM restaurants r 
            JOIN user_sessions us ON r.id = us.user_id 
            WHERE us.user_id = restaurants.id AND us.is_active = true
        )
    );

-- Favorites table policies
CREATE POLICY "Users can manage own favorites" ON favorites
    FOR ALL USING (auth.uid() = user_id);

-- Notifications table policies
CREATE POLICY "Users can view own notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can mark notifications as read" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- User sessions table policies
CREATE POLICY "Users can view own sessions" ON user_sessions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own sessions" ON user_sessions
    FOR DELETE USING (auth.uid() = user_id);

-- ==================== FUNCTIONS FOR API ====================

-- Function for proximity search
CREATE OR REPLACE FUNCTION proximity_search(
    p_latitude DECIMAL,
    p_longitude DECIMAL,
    p_radius DECIMAL DEFAULT 10.0,
    p_limit INTEGER DEFAULT 50
)
RETURNS TABLE(id UUID, name TEXT, distance DECIMAL) AS $$
BEGIN
    RETURN QUERY
    SELECT r.id, r.name, 
           earth_distance(
               ll_to_earth(r.latitude, r.longitude),
               ll_to_earth(p_latitude, p_longitude)
           ) / 1609.344 as distance -- Convert to miles
    FROM restaurants r
    WHERE earth_distance(
            ll_to_earth(r.latitude, r.longitude),
            ll_to_earth(p_latitude, p_longitude)
        ) / 1609.344 <= p_radius
      AND r.is_available = true
    ORDER BY distance
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to get user order history
CREATE OR REPLACE FUNCTION get_user_order_history(
    p_user_id UUID,
    p_limit INTEGER DEFAULT 20,
    p_offset INTEGER DEFAULT 0
)
RETURNS TABLE(
    id UUID,
    order_number VARCHAR,
    restaurant_name TEXT,
    status order_status,
    total_amount DECIMAL,
    created_at TIMESTAMP WITH TIME ZONE
) AS $$
BEGIN
    RETURN QUERY
    SELECT o.id, o.order_number, r.name as restaurant_name, 
           o.status, o.total_amount, o.created_at
    FROM orders o
    JOIN restaurants r ON o.restaurant_id = r.id
    WHERE o.user_id = p_user_id
    ORDER BY o.created_at DESC
    LIMIT p_limit OFFSET p_offset;
END;
$$ LANGUAGE plpgsql;

-- Function to validate and apply coupon
CREATE OR REPLACE FUNCTION apply_coupon(
    p_user_id UUID,
    p_coupon_code VARCHAR,
    p_order_amount DECIMAL
)
RETURNS TABLE(success BOOLEAN, discount_amount DECIMAL, message TEXT) AS $$
DECLARE
    v_coupon_record RECORD;
    v_usage_count INTEGER;
BEGIN
    -- Get coupon details
    SELECT c.id, c.discount_type, c.discount_value, c.minimum_order_amount, 
           c.max_discount_amount, c.max_uses, c.used_count, c.valid_until
    INTO v_coupon_record
    FROM coupons c
    WHERE c.code = p_coupon_code AND c.is_active = true;
    
    -- Check if coupon exists
    IF NOT FOUND THEN
        RETURN QUERY SELECT false, 0.0::DECIMAL, 'Invalid coupon code';
        RETURN;
    END IF;
    
    -- Check if coupon is still valid
    IF v_coupon_record.valid_until IS NOT NULL AND v_coupon_record.valid_until < NOW() THEN
        RETURN QUERY SELECT false, 0.0::DECIMAL, 'Coupon has expired';
        RETURN;
    END IF;
    
    -- Check minimum order amount
    IF p_order_amount < v_coupon_record.minimum_order_amount THEN
        RETURN QUERY SELECT false, 0.0::DECIMAL, 
                   'Minimum order amount of $' || v_coupon_record.minimum_order_amount || ' required';
        RETURN;
    END IF;
    
    -- Check if user has already used this coupon
    SELECT COUNT(*) INTO v_usage_count
    FROM coupon_usage
    WHERE user_id = p_user_id AND coupon_id = v_coupon_record.id;
    
    IF v_usage_count > 0 THEN
        RETURN QUERY SELECT false, 0.0::DECIMAL, 'Coupon already used';
        RETURN;
    END IF;
    
    -- Check if coupon has reached max uses
    IF v_coupon_record.max_uses IS NOT NULL AND v_coupon_record.used_count >= v_coupon_record.max_uses THEN
        RETURN QUERY SELECT false, 0.0::DECIMAL, 'Coupon usage limit reached';
        RETURN;
    END IF;
    
    -- Calculate discount
    DECLARE
        v_discount_amount DECIMAL;
    BEGIN
        IF v_coupon_record.discount_type = 'percentage' THEN
            v_discount_amount := p_order_amount * (v_coupon_record.discount_value / 100.0);
        ELSE
            v_discount_amount := v_coupon_record.discount_value;
        END IF;
        
        -- Apply max discount limit if set
        IF v_coupon_record.max_discount_amount IS NOT NULL AND v_discount_amount > v_coupon_record.max_discount_amount THEN
            v_discount_amount := v_coupon_record.max_discount_amount;
        END IF;
        
        RETURN QUERY SELECT true, v_discount_amount, 'Coupon applied successfully';
    END;
END;
$$ LANGUAGE plpgsql;

-- Function to get restaurant statistics
CREATE OR REPLACE FUNCTION get_restaurant_stats(p_restaurant_id UUID)
RETURNS TABLE(
    total_orders BIGINT,
    total_revenue DECIMAL,
    avg_rating DECIMAL,
    review_count BIGINT,
    popular_items JSON
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COALESCE(COUNT(o.id), 0) as total_orders,
        COALESCE(SUM(o.total_amount), 0) as total_revenue,
        COALESCE(AVG(r.rating), 0) as avg_rating,
        COALESCE(COUNT(r.id), 0) as review_count,
        (
            SELECT json_agg(
                json_build_object(
                    'name', mi.name,
                    'order_count', COALESCE(item_counts.count, 0),
                    'price', mi.price
                )
            )
            FROM (
                SELECT oi.menu_item_id, COUNT(*) as count
                FROM order_items oi
                JOIN orders o ON oi.order_id = o.id
                WHERE o.restaurant_id = p_restaurant_id
                GROUP BY oi.menu_item_id
                ORDER BY count DESC
                LIMIT 5
            ) item_counts
            JOIN menu_items mi ON item_counts.menu_item_id = mi.id
        ) as popular_items
    FROM restaurants r
    LEFT JOIN orders o ON r.id = o.restaurant_id
    LEFT JOIN reviews rev ON r.id = rev.restaurant_id
    LEFT JOIN reviews r ON r.id = r.restaurant_id
    WHERE r.id = p_restaurant_id;
END;
$$ LANGUAGE plpgsql;

-- ==================== VIEWS ====================

-- Restaurant details view
CREATE VIEW restaurant_details_view AS
SELECT 
    r.id,
    r.name,
    r.description,
    r.image_url,
    r.address,
    r.latitude,
    r.longitude,
    r.rating,
    r.review_count,
    r.delivery_time,
    r.delivery_fee,
    r.minimum_order,
    r.phone_number,
    r.opening_hours,
    r.is_available,
    r.is_featured,
    COALESCE(menu_count.item_count, 0) as menu_item_count,
    COALESCE(week_order_count.sales, 0) as weekly_orders,
    COALESCE(avg_check.avg_order_value, 0) as avg_check
FROM restaurants r
LEFT JOIN (
    SELECT restaurant_id, COUNT(*) as item_count
    FROM menu_items
    WHERE is_available = true
    GROUP BY restaurant_id
) menu_count ON r.id = menu_count.restaurant_id
LEFT JOIN (
    SELECT restaurant_id, COUNT(*) as sales
    FROM orders
    WHERE created_at >= NOW() - INTERVAL '7 days'
    GROUP BY restaurant_id
) week_order_count ON r.id = week_order_count.restaurant_id
LEFT JOIN (
    SELECT restaurant_id, AVG(total_amount) as avg_order_value
    FROM orders
    WHERE status NOT IN ('cancelled', 'refunded')
    GROUP BY restaurant_id
) avg_check ON r.id = avg_check.restaurant_id;

-- User order statistics view
CREATE VIEW user_order_stats_view AS
SELECT 
    u.id as user_id,
    u.full_name,
    COALESCE(order_stats.total_orders, 0) as total_orders,
    COALESCE(order_stats.total_spent, 0) as total_spent,
    COALESCE(order_stats.avg_order_value, 0) as avg_order_value,
    COALESCE(review_stats.total_reviews, 0) as total_reviews,
    COALESCE(review_stats.avg_rating, 0) as user_avg_rating,
    order_stats.last_order_date
FROM users u
LEFT JOIN (
    SELECT 
        user_id,
        COUNT(*) as total_orders,
        SUM(total_amount) as total_spent,
        AVG(total_amount) as avg_order_value,
        MAX(created_at) as last_order_date
    FROM orders
    WHERE status NOT IN ('cancelled', 'refunded')
    GROUP BY user_id
) order_stats ON u.id = order_stats.user_id
LEFT JOIN (
    SELECT user_id, COUNT(*) as total_reviews, AVG(rating) as avg_rating
    FROM reviews
    GROUP BY user_id
) review_stats ON u.id = review_stats.user_id;

-- ==================== SAMPLE DATA (for development) ====================

-- This section would be commented out in production but included for development/testing
-- Categories
INSERT INTO categories (name, description, image_url, display_order) VALUES
('American', 'Classic American comfort food', 'https://example.com/american.jpg', 1),
('Italian', 'Italian pizzas and pasta dishes', 'https://example.com/italian.jpg', 2),
('Asian', 'Asian fusion and traditional dishes', 'https://example.com/asian.jpg', 3),
('Mexican', 'Mexican tacos, burritos, and more', 'https://example.com/mexican.jpg', 4),
('Healthy', 'Fresh and healthy meal options', 'https://example.com/healthy.jpg', 5);
