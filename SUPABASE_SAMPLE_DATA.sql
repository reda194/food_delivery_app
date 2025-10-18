-- =====================================================
-- FOOD DELIVERY APP - SAMPLE DATA
-- =====================================================
-- Use this to populate your database with test data
-- Run this AFTER running SUPABASE_SCHEMA.sql
-- =====================================================

-- =====================================================
-- SAMPLE RESTAURANTS
-- =====================================================

INSERT INTO public.restaurants (
  name, slug, description, image_url, cover_image_url, cuisine_type,
  rating, total_reviews, delivery_time_min, delivery_time_max,
  delivery_fee, min_order_amount, address, city, state,
  latitude, longitude, is_open, is_accepting_orders, is_featured, phone_number
) VALUES
(
  'Pizza Palace',
  'pizza-palace',
  'Authentic Italian pizzas made with fresh ingredients and love. Our wood-fired oven creates the perfect crispy crust every time.',
  'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
  'https://images.unsplash.com/photo-1571997478779-2adcbbe9ab2f?w=1200',
  ARRAY['Italian', 'Pizza'],
  4.5,
  328,
  25,
  35,
  2.99,
  15.00,
  '123 Main St',
  'New York',
  'NY',
  40.7128,
  -74.0060,
  true,
  true,
  true,
  '+1-555-0101'
),
(
  'Burger Hub',
  'burger-hub',
  'Gourmet burgers with premium ingredients. From classic cheeseburgers to exotic creations.',
  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
  'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1200',
  ARRAY['American', 'Burgers'],
  4.3,
  215,
  20,
  30,
  2.50,
  12.00,
  '456 Oak Ave',
  'New York',
  'NY',
  40.7580,
  -73.9855,
  true,
  true,
  true,
  '+1-555-0102'
),
(
  'Sushi Bar',
  'sushi-bar',
  'Fresh sushi prepared by expert chefs. Experience authentic Japanese cuisine.',
  'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=800',
  'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=1200',
  ARRAY['Japanese', 'Sushi'],
  4.7,
  456,
  30,
  45,
  3.99,
  20.00,
  '789 Park Blvd',
  'New York',
  'NY',
  40.7589,
  -73.9851,
  true,
  true,
  true,
  '+1-555-0103'
),
(
  'Taco Fiesta',
  'taco-fiesta',
  'Authentic Mexican street food. Tacos, burritos, and more!',
  'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=800',
  'https://images.unsplash.com/photo-1613514785940-daed07799d6b?w=1200',
  ARRAY['Mexican', 'Tacos'],
  4.4,
  189,
  15,
  25,
  2.00,
  10.00,
  '321 Sunset Dr',
  'New York',
  'NY',
  40.7410,
  -73.9896,
  true,
  true,
  false,
  '+1-555-0104'
),
(
  'Dragon Wok',
  'dragon-wok',
  'Traditional Chinese cuisine with modern flavors. Family recipes passed down for generations.',
  'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=800',
  'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=1200',
  ARRAY['Chinese', 'Asian'],
  4.2,
  298,
  25,
  40,
  3.50,
  18.00,
  '555 Broadway',
  'New York',
  'NY',
  40.7251,
  -74.0048,
  true,
  true,
  false,
  '+1-555-0105'
),
(
  'Pasta Paradise',
  'pasta-paradise',
  'Homemade pasta and traditional Italian dishes. Like nonna used to make!',
  'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800',
  'https://images.unsplash.com/photo-1556761223-4c4282c73f77?w=1200',
  ARRAY['Italian', 'Pasta'],
  4.6,
  412,
  30,
  45,
  2.99,
  16.00,
  '777 Italian Way',
  'New York',
  'NY',
  40.7484,
  -73.9857,
  true,
  true,
  true,
  '+1-555-0106'
);

-- =====================================================
-- MENU ITEMS FOR PIZZA PALACE
-- =====================================================

WITH pizza_palace AS (
  SELECT id FROM public.restaurants WHERE slug = 'pizza-palace'
),
pizza_cat AS (
  SELECT id FROM public.categories WHERE name = 'Pizza'
)
INSERT INTO public.menu_items (
  restaurant_id, category_id, name, slug, description,
  price, image_url, is_available, is_vegetarian, prep_time, rating, total_reviews
)
SELECT
  pp.id,
  pc.id,
  'Margherita Pizza',
  'margherita-pizza',
  'Classic pizza with fresh mozzarella, tomatoes, and basil',
  12.99,
  'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=600',
  true,
  true,
  25,
  4.7,
  89
FROM pizza_palace pp, pizza_cat pc
UNION ALL
SELECT
  pp.id,
  pc.id,
  'Pepperoni Paradise',
  'pepperoni-paradise',
  'Loaded with premium pepperoni and extra cheese',
  14.99,
  'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=600',
  true,
  false,
  25,
  4.8,
  156
FROM pizza_palace pp, pizza_cat pc
UNION ALL
SELECT
  pp.id,
  pc.id,
  'Veggie Supreme',
  'veggie-supreme',
  'Fresh vegetables, mushrooms, bell peppers, and olives',
  13.99,
  'https://images.unsplash.com/photo-1511689660979-10d2b1aada49?w=600',
  true,
  true,
  25,
  4.5,
  67
FROM pizza_palace pp, pizza_cat pc
UNION ALL
SELECT
  pp.id,
  pc.id,
  'Meat Lovers',
  'meat-lovers',
  'Pepperoni, sausage, bacon, and ham',
  16.99,
  'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?w=600',
  true,
  false,
  30,
  4.6,
  112
FROM pizza_palace pp, pizza_cat pc;

-- =====================================================
-- MENU ITEMS FOR BURGER HUB
-- =====================================================

WITH burger_hub AS (
  SELECT id FROM public.restaurants WHERE slug = 'burger-hub'
),
burger_cat AS (
  SELECT id FROM public.categories WHERE name = 'Burgers'
)
INSERT INTO public.menu_items (
  restaurant_id, category_id, name, slug, description,
  price, image_url, is_available, prep_time, rating, total_reviews
)
SELECT
  bh.id,
  bc.id,
  'Classic Cheeseburger',
  'classic-cheeseburger',
  'Angus beef patty with cheddar cheese, lettuce, tomato, and our special sauce',
  9.99,
  'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600',
  true,
  15,
  4.5,
  234
FROM burger_hub bh, burger_cat bc
UNION ALL
SELECT
  bh.id,
  bc.id,
  'Bacon Deluxe',
  'bacon-deluxe',
  'Double beef patty with crispy bacon, cheese, and BBQ sauce',
  12.99,
  'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=600',
  true,
  20,
  4.7,
  189
FROM burger_hub bh, burger_cat bc
UNION ALL
SELECT
  bh.id,
  bc.id,
  'Veggie Burger',
  'veggie-burger',
  'Plant-based patty with avocado, sprouts, and chipotle mayo',
  10.99,
  'https://images.unsplash.com/photo-1520072959219-c595dc870360?w=600',
  true,
  15,
  4.3,
  78
FROM burger_hub bh, burger_cat bc;

-- =====================================================
-- MENU ITEMS FOR SUSHI BAR
-- =====================================================

WITH sushi_bar AS (
  SELECT id FROM public.restaurants WHERE slug = 'sushi-bar'
),
sushi_cat AS (
  SELECT id FROM public.categories WHERE name = 'Sushi'
)
INSERT INTO public.menu_items (
  restaurant_id, category_id, name, slug, description,
  price, image_url, is_available, prep_time, rating, total_reviews
)
SELECT
  sb.id,
  sc.id,
  'California Roll',
  'california-roll',
  'Crab, avocado, and cucumber wrapped in rice and seaweed',
  8.99,
  'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=600',
  true,
  20,
  4.6,
  312
FROM sushi_bar sb, sushi_cat sc
UNION ALL
SELECT
  sb.id,
  sc.id,
  'Spicy Tuna Roll',
  'spicy-tuna-roll',
  'Fresh tuna with spicy mayo and cucumber',
  10.99,
  'https://images.unsplash.com/photo-1564489563601-c53cfc451e93?w=600',
  true,
  20,
  4.8,
  256
FROM sushi_bar sb, sushi_cat sc
UNION ALL
SELECT
  sb.id,
  sc.id,
  'Dragon Roll',
  'dragon-roll',
  'Shrimp tempura, avocado, topped with eel and eel sauce',
  14.99,
  'https://images.unsplash.com/photo-1617196034796-73dfa7b1fd56?w=600',
  true,
  25,
  4.9,
  445
FROM sushi_bar sb, sushi_cat sc
UNION ALL
SELECT
  sb.id,
  sc.id,
  'Salmon Nigiri (6pc)',
  'salmon-nigiri',
  'Six pieces of premium salmon over seasoned rice',
  12.99,
  'https://images.unsplash.com/photo-1580822184713-fc5400e7fe10?w=600',
  true,
  15,
  4.7,
  198
FROM sushi_bar sb, sushi_cat sc;

-- =====================================================
-- SAMPLE PROMO CODES
-- =====================================================

INSERT INTO public.promo_codes (
  code, description, discount_type, discount_value,
  max_discount_amount, min_order_amount, max_uses,
  max_uses_per_user, valid_until, is_active
) VALUES
(
  'WELCOME50',
  'Welcome! Get 50% off your first order',
  'percentage',
  50,
  20.00,
  15.00,
  1000,
  1,
  NOW() + INTERVAL '30 days',
  true
),
(
  'FREESHIP',
  'Free delivery on orders over $25',
  'free_delivery',
  0,
  NULL,
  25.00,
  NULL,
  1,
  NOW() + INTERVAL '60 days',
  true
),
(
  'SAVE10',
  'Save $10 on orders over $40',
  'fixed_amount',
  10.00,
  NULL,
  40.00,
  NULL,
  3,
  NOW() + INTERVAL '90 days',
  true
),
(
  'WEEKEND20',
  '20% off weekend orders',
  'percentage',
  20,
  15.00,
  20.00,
  NULL,
  1,
  NOW() + INTERVAL '7 days',
  true
);

-- =====================================================
-- SAMPLE REVIEWS
-- =====================================================

-- Note: You'll need actual user IDs after creating test accounts
-- This is a template - update with real user_id after account creation

-- INSERT INTO public.reviews (
--   user_id,
--   restaurant_id,
--   rating,
--   title,
--   comment,
--   food_rating,
--   service_rating,
--   delivery_rating,
--   is_verified_purchase
-- )
-- SELECT
--   'YOUR_USER_ID_HERE'::UUID,
--   id,
--   5,
--   'Amazing Pizza!',
--   'Best pizza I''ve had in New York. The crust was perfect and toppings were fresh.',
--   5,
--   5,
--   5,
--   true
-- FROM public.restaurants WHERE slug = 'pizza-palace';

-- =====================================================
-- RESTAURANT HOURS (Open 7 days, 11am-10pm)
-- =====================================================

WITH restaurant_ids AS (
  SELECT id FROM public.restaurants
)
INSERT INTO public.restaurant_hours (restaurant_id, day_of_week, open_time, close_time, is_closed)
SELECT
  id,
  day,
  '11:00:00'::TIME,
  '22:00:00'::TIME,
  false
FROM restaurant_ids
CROSS JOIN generate_series(0, 6) AS day;

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

DO $$
DECLARE
  restaurant_count INTEGER;
  menu_item_count INTEGER;
  promo_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO restaurant_count FROM public.restaurants;
  SELECT COUNT(*) INTO menu_item_count FROM public.menu_items;
  SELECT COUNT(*) INTO promo_count FROM public.promo_codes;

  RAISE NOTICE '=====================================================';
  RAISE NOTICE 'SAMPLE DATA INSERTION COMPLETE! ✅';
  RAISE NOTICE '=====================================================';
  RAISE NOTICE '';
  RAISE NOTICE 'Restaurants Created: %', restaurant_count;
  RAISE NOTICE 'Menu Items Created: %', menu_item_count;
  RAISE NOTICE 'Promo Codes Created: %', promo_count;
  RAISE NOTICE 'Categories: 10 (from schema)';
  RAISE NOTICE '';
  RAISE NOTICE 'Test Promo Codes:';
  RAISE NOTICE '  - WELCOME50 (50%% off first order)';
  RAISE NOTICE '  - FREESHIP (Free delivery over $25)';
  RAISE NOTICE '  - SAVE10 ($10 off orders over $40)';
  RAISE NOTICE '  - WEEKEND20 (20%% off weekend orders)';
  RAISE NOTICE '';
  RAISE NOTICE 'Next Steps:';
  RAISE NOTICE '1. Create a test account in your app';
  RAISE NOTICE '2. Browse restaurants';
  RAISE NOTICE '3. Add items to cart';
  RAISE NOTICE '4. Try promo codes at checkout';
  RAISE NOTICE '5. Place a test order';
  RAISE NOTICE '';
  RAISE NOTICE '=====================================================';
END $$;
