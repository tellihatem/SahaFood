import { PrismaClient } from '@prisma/client';
import * as argon2 from 'argon2';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting database seed...');

  // Create admin user
  const adminPassword = await argon2.hash('admin123456');
  const admin = await prisma.user.upsert({
    where: { phone: '+213555000001' },
    update: {},
    create: {
      phone: '+213555000001',
      phone_verified: true,
      password_hash: adminPassword,
      name: 'مدير النظام',
      role: 'admin',
    },
  });
  console.log('✅ Admin user created:', admin.id);

  // Create chef/restaurant owner user
  const chefPassword = await argon2.hash('chef123456');
  const chef = await prisma.user.upsert({
    where: { phone: '+213555000002' },
    update: {},
    create: {
      phone: '+213555000002',
      phone_verified: true,
      password_hash: chefPassword,
      name: 'صاحب المطعم',
      role: 'chef',
    },
  });
  console.log('✅ Chef user created:', chef.id);

  // Create delivery user
  const deliveryPassword = await argon2.hash('delivery123456');
  const delivery = await prisma.user.upsert({
    where: { phone: '+213555000003' },
    update: {},
    create: {
      phone: '+213555000003',
      phone_verified: true,
      password_hash: deliveryPassword,
      name: 'عامل التوصيل',
      role: 'delivery',
    },
  });
  console.log('✅ Delivery user created:', delivery.id);

  // Create delivery profile
  await prisma.deliveryProfile.upsert({
    where: { user_id: delivery.id },
    update: {},
    create: {
      user_id: delivery.id,
      vehicle_details: 'دراجة نارية - Honda',
      availability_status: 'online',
      current_latitude: 36.7538,
      current_longitude: 3.0588,
    },
  });
  console.log('✅ Delivery profile created');

  // Create regular user
  const userPassword = await argon2.hash('user123456');
  const user = await prisma.user.upsert({
    where: { phone: '+213555000004' },
    update: {},
    create: {
      phone: '+213555000004',
      phone_verified: true,
      password_hash: userPassword,
      name: 'مستخدم عادي',
      role: 'user',
    },
  });
  console.log('✅ Regular user created:', user.id);

  // Create user address
  const address = await prisma.address.create({
    data: {
      user_id: user.id,
      label: 'المنزل',
      street: 'شارع ديدوش مراد',
      city: 'الجزائر العاصمة',
      latitude: 36.7538,
      longitude: 3.0588,
      is_default: true,
    },
  });
  console.log('✅ User address created:', address.id);

  // Create sample restaurant
  const restaurant = await prisma.restaurant.upsert({
    where: { slug: 'pizza-house' },
    update: {},
    create: {
      name: 'بيت البيتزا',
      slug: 'pizza-house',
      description: 'أفضل بيتزا في المدينة مع مكونات طازجة ووصفات إيطالية أصيلة',
      address: 'شارع الاستقلال، الجزائر العاصمة',
      latitude: 36.7538,
      longitude: 3.0588,
      image_url: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
      phone: '+213555100001',
      opening_hours: [
        { day: 'السبت', open: '10:00', close: '23:00' },
        { day: 'الأحد', open: '10:00', close: '23:00' },
        { day: 'الإثنين', open: '10:00', close: '23:00' },
        { day: 'الثلاثاء', open: '10:00', close: '23:00' },
        { day: 'الأربعاء', open: '10:00', close: '23:00' },
        { day: 'الخميس', open: '10:00', close: '23:00' },
        { day: 'الجمعة', open: '14:00', close: '23:00' },
      ],
      is_active: true,
      rating: 4.5,
      owner_id: chef.id,
      categories: ['بيتزا', 'إيطالي', 'وجبات سريعة'],
    },
  });
  console.log('✅ Restaurant created:', restaurant.id);

  // Link delivery person to restaurant
  await prisma.restaurantDeliveryPerson.upsert({
    where: {
      restaurant_id_user_id: {
        restaurant_id: restaurant.id,
        user_id: delivery.id,
      },
    },
    update: {},
    create: {
      restaurant_id: restaurant.id,
      user_id: delivery.id,
    },
  });
  console.log('✅ Delivery person linked to restaurant');

  // Create sample foods
  const foods = await Promise.all([
    prisma.food.create({
      data: {
        name: 'بيتزا مارغريتا',
        description: 'صلصة طماطم، موزاريلا، ريحان طازج',
        price: 800,
        image_url: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002',
        categories: 'بيتزا,كلاسيكي',
        is_available: true,
        restaurant_id: restaurant.id,
      },
    }),
    prisma.food.create({
      data: {
        name: 'بيتزا بيبروني',
        description: 'صلصة طماطم، موزاريلا، بيبروني حار',
        price: 950,
        image_url: 'https://images.unsplash.com/photo-1628840042765-356cda07504e',
        categories: 'بيتزا,حار',
        is_available: true,
        restaurant_id: restaurant.id,
      },
    }),
    prisma.food.create({
      data: {
        name: 'بيتزا خضروات',
        description: 'صلصة طماطم، موزاريلا، فلفل، زيتون، فطر، بصل',
        price: 850,
        image_url: 'https://images.unsplash.com/photo-1511689660979-10d2b1aada49',
        categories: 'بيتزا,نباتي',
        is_available: true,
        restaurant_id: restaurant.id,
      },
    }),
    prisma.food.create({
      data: {
        name: 'بيتزا أربع أجبان',
        description: 'موزاريلا، غورغونزولا، بارميزان، ريكوتا',
        price: 1100,
        image_url: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
        categories: 'بيتزا,جبن',
        is_available: true,
        restaurant_id: restaurant.id,
      },
    }),
  ]);
  console.log('✅ Foods created:', foods.length);

  // Create sample voucher
  const voucher = await prisma.voucher.upsert({
    where: { code: 'WELCOME20' },
    update: {},
    create: {
      code: 'WELCOME20',
      description: 'خصم 20% للمستخدمين الجدد',
      discount_value: 20,
      discount_type: 'PERCENTAGE',
      max_discount: 500,
      min_order_value: 1000,
      is_active: true,
      expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 30 days
    },
  });
  console.log('✅ Voucher created:', voucher.code);

  // Create sample advertisement
  const ad = await prisma.advertisement.create({
    data: {
      title: 'عروض نهاية الأسبوع',
      description: 'احصل على خصم 30% على جميع الطلبات',
      image_url: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
      target_url: '/promotions/weekend',
      placement: 'home',
      is_active: true,
      start_date: new Date(),
      end_date: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
    },
  }).catch(() => {
    // If advertisement already exists, find existing one
    return prisma.advertisement.findFirst({
      where: { title: 'عروض نهاية الأسبوع' }
    });
  });
  console.log('✅ Advertisement created:', ad.id);

  console.log('🎉 Database seed completed successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
