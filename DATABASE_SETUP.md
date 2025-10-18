# Database Setup Guide

## 🗄️ Complete Supabase Database Setup

**Time Required:** 10 minutes
**Difficulty:** Easy

---

## Step 1: Open Supabase SQL Editor

1. Go to your Supabase project dashboard
2. Click **"SQL Editor"** in the left sidebar
3. Click **"New Query"** button

---

## Step 2: Run Schema (Create Tables)

1. Open the file: **`SUPABASE_SCHEMA.sql`**
2. **Copy ALL content** (Ctrl+A, Ctrl+C)
3. **Paste** into Supabase SQL Editor
4. Click **"Run"** button (or press Ctrl+Enter)
5. Wait for "Success" message (30-60 seconds)

### What This Creates:
- ✅ 15 tables (users, restaurants, orders, etc.)
- ✅ 40+ indexes for fast queries
- ✅ 5 triggers for automation
- ✅ 25+ security policies (RLS)
- ✅ 10 food categories (Pizza, Burgers, etc.)

---

## Step 3: Add Sample Data (Optional but Recommended)

1. Create **another new query** in SQL Editor
2. Open the file: **`SUPABASE_SAMPLE_DATA.sql`**
3. **Copy ALL content**
4. **Paste** into the new query
5. Click **"Run"**
6. Wait for "Success" message

### What This Adds:
- ✅ 6 sample restaurants
- ✅ 15+ menu items with prices and images
- ✅ 4 promo codes you can use
- ✅ Restaurant operating hours

---

## Step 4: Verify Installation

### Check Tables Were Created:

1. Go to **Database** → **Tables** in Supabase sidebar
2. You should see these tables:
   ```
   ✓ users
   ✓ categories
   ✓ restaurants
   ✓ restaurant_hours
   ✓ menu_items
   ✓ addresses
   ✓ payment_methods
   ✓ promo_codes
   ✓ orders
   ✓ order_items
   ✓ favorites
   ✓ reviews
   ✓ notifications
   ✓ cart
   ✓ cart_items
   ```

### Check Sample Data:

1. Click on **`restaurants`** table
2. You should see 6 restaurants:
   - Pizza Palace
   - Burger Hub
   - Sushi Bar
   - Taco Fiesta
   - Dragon Wok
   - Pasta Paradise

3. Click on **`menu_items`** table
4. You should see 15+ food items with prices

5. Click on **`categories`** table
6. You should see 10 categories (Pizza, Burgers, Sushi, etc.)

---

## Step 5: Get Your Credentials

1. Go to **Settings** → **API** in Supabase
2. Copy these two values:

   ```
   Project URL: https://your-project-id.supabase.co
   anon/public key: your-anon-key-here
   ```

---

## Step 6: Update Flutter App

Open: `food_delivery_app/lib/core/constants/app_constants.dart`

Replace these lines (around line 10-14):

```dart
// BEFORE:
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';

// AFTER (paste your actual values):
static const String supabaseUrl = 'https://your-project-id.supabase.co';
static const String supabaseAnonKey = 'your-anon-key-here';
```

**⚠️ IMPORTANT:** Don't share these credentials publicly!

---

## Step 7: Test the Connection

```bash
cd food_delivery_app
flutter clean
flutter pub get
flutter run
```

### What to Test:

1. **Create Account**
   - Open app → Sign Up
   - Enter email and password
   - Check Supabase **Authentication** tab to see your user

2. **View Restaurants**
   - After login, you should see 6 restaurants
   - With images and details

3. **Browse Menu**
   - Click any restaurant
   - You should see menu items with prices

4. **Try Promo Code**
   - Add items to cart
   - At checkout, try: `WELCOME50`
   - Should get 50% discount!

---

## 🎯 Quick Verification Checklist

Run through this checklist to make sure everything works:

### Database
- [ ] SUPABASE_SCHEMA.sql executed successfully
- [ ] SUPABASE_SAMPLE_DATA.sql executed successfully
- [ ] 15 tables visible in Supabase Dashboard
- [ ] Sample restaurants visible in `restaurants` table
- [ ] Sample menu items visible in `menu_items` table

### App Configuration
- [ ] Supabase URL updated in app_constants.dart
- [ ] Supabase anon key updated in app_constants.dart
- [ ] No placeholder values left (`your-project-id`, `your-anon-key-here`)

### App Functionality
- [ ] App builds without errors
- [ ] Can create new account
- [ ] Can login with created account
- [ ] Can see restaurants on home screen
- [ ] Can view restaurant details
- [ ] Can add items to cart
- [ ] Promo code works

---

## 🐛 Troubleshooting

### Problem: "Success" message but no tables created

**Solution:**
- Refresh your browser
- Go to Database → Tables
- Check if tables appear now
- If not, check for error messages in SQL Editor

### Problem: "Error" when running schema

**Solution:**
1. Check if you have an existing database
2. The schema uses `CREATE TABLE IF NOT EXISTS` so it's safe to re-run
3. Look at the specific error message
4. Common issue: Previous failed run - just run again

### Problem: Sample data fails with "foreign key violation"

**Solution:**
- Make sure you ran SUPABASE_SCHEMA.sql FIRST
- Then run SUPABASE_SAMPLE_DATA.sql
- Order matters!

### Problem: App shows "connection refused"

**Solution:**
1. Verify Supabase URL in app_constants.dart
2. Check your internet connection
3. Verify Supabase project is not paused (free tier pauses after inactivity)
4. Go to Supabase Dashboard and click your project to wake it up

### Problem: "Invalid API key"

**Solution:**
1. Make sure you copied the **anon/public** key, NOT the service_role key
2. Check for extra spaces when copying
3. Make sure the entire key is copied (it's very long!)

### Problem: Can create account but can't see restaurants

**Solution:**
1. Check if sample data was inserted: Database → Tables → restaurants
2. If empty, run SUPABASE_SAMPLE_DATA.sql
3. Check browser console / app logs for errors
4. Verify RLS policies are enabled (they are in the schema)

---

## 📊 Database Statistics

After setup, your database will have:

| Item | Count |
|------|-------|
| Tables | 15 |
| Indexes | 40+ |
| Triggers | 5 |
| Functions | 5 |
| RLS Policies | 25+ |
| Sample Restaurants | 6 |
| Sample Menu Items | 15+ |
| Categories | 10 |
| Promo Codes | 4 |

---

## 🔐 Security Notes

### What's Protected:
- ✅ Row Level Security (RLS) enabled on all tables
- ✅ Users can only see/edit their own data
- ✅ Restaurants and menus are read-only for users
- ✅ Orders are private to each user
- ✅ Payment methods are encrypted (in production)

### What You Should Do:
- ❌ Never commit Supabase credentials to Git
- ✅ Add `app_constants.dart` to `.gitignore`
- ✅ Use environment variables in production
- ✅ Enable email verification in Supabase Auth settings
- ✅ Set up rate limiting (Supabase Dashboard → Settings)

---

## 🎨 Sample Promo Codes

Test these in your app:

| Code | Discount | Min Order | Uses |
|------|----------|-----------|------|
| `WELCOME50` | 50% off | $15 | 1 per user |
| `FREESHIP` | Free delivery | $25 | 1 per user |
| `SAVE10` | $10 off | $40 | 3 per user |
| `WEEKEND20` | 20% off | $20 | 1 per user |

---

## 📱 Sample Test Flow

1. **Sign Up**: test@example.com / Password123!
2. **Browse**: See 6 restaurants
3. **Select**: Click "Pizza Palace"
4. **Add to Cart**: "Pepperoni Paradise" ($14.99)
5. **Add More**: "Margherita Pizza" ($12.99)
6. **Checkout**: Total = $27.98 + fees
7. **Apply Promo**: Enter "WELCOME50"
8. **Discount**: Get 50% off (save $13.99)
9. **Place Order**: Final total ~$17 (with fees)

---

## 🚀 Next Steps

After database setup:

1. ✅ **Test authentication** - Create account, login, logout
2. ✅ **Test browsing** - View restaurants and menu items
3. ✅ **Test cart** - Add items, update quantities
4. ✅ **Test checkout** - Add address, payment method, place order
5. ✅ **Test promo codes** - Apply discount codes
6. ⏳ **Add more data** - Create your own restaurants
7. ⏳ **Customize** - Update images, prices, descriptions
8. ⏳ **Extend** - Add new features

---

## 📚 Useful SQL Queries

### View all restaurants:
```sql
SELECT name, rating, delivery_fee FROM restaurants;
```

### View all menu items with restaurant name:
```sql
SELECT
  r.name as restaurant,
  m.name as item,
  m.price
FROM menu_items m
JOIN restaurants r ON r.id = m.restaurant_id;
```

### View all active promo codes:
```sql
SELECT code, discount_type, discount_value, min_order_amount
FROM promo_codes
WHERE is_active = true;
```

### View all users:
```sql
SELECT email, full_name, created_at FROM users;
```

### View all orders:
```sql
SELECT
  order_number,
  status,
  total,
  created_at
FROM orders
ORDER BY created_at DESC;
```

---

## ✅ Success!

If you've completed all steps and the checklist, your database is ready!

**You can now:**
- Create user accounts
- Browse restaurants
- View menu items
- Add items to cart
- Use promo codes
- Place orders
- Leave reviews

**Next:** Start building features or customize the sample data!

---

## 💡 Tips

1. **Bookmark** your Supabase project URL for quick access
2. **Use** the Supabase Dashboard to view data in real-time
3. **Monitor** the Logs section to debug issues
4. **Check** the Auth section to see registered users
5. **Explore** Table Editor to manually add/edit data

---

**Need help?** Check QUICK_START_IMPLEMENTATION.md for more details!
