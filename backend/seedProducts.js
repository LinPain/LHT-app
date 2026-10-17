const mongoose = require('mongoose');
require('dotenv').config();

const Product = require('./src/models/Product');

const products = [
  {
    name: 'Hồng Trà Sữa',
    description: 'Hồng trà kết hợp sữa thơm béo.',
    price: 35000,
    imageUrl: '',
    category: 'Trà sữa',
    isAvailable: true,

    sizes: [
      { name: 'M', extraPrice: 0 },
      { name: 'L', extraPrice: 5000 },
    ],

    sugarLevels: [
      { name: '0%', extraPrice: 0 },
      { name: '50%', extraPrice: 0 },
      { name: '100%', extraPrice: 0 },
    ],

    iceLevels: [
      { name: 'Không đá', extraPrice: 0 },
      { name: 'Ít đá', extraPrice: 0 },
      { name: 'Bình thường', extraPrice: 0 },
    ],

    toppings: [
      { name: 'Trân châu', extraPrice: 5000 },
      { name: 'Thạch', extraPrice: 5000 },
    ],
  },

  {
    name: 'Trà Đào Cam Sả',
    description: 'Trà đào thanh mát kết hợp cam và sả.',
    price: 39000,
    imageUrl: '',
    category: 'Trà trái cây',
    isAvailable: true,

    sizes: [
      { name: 'M', extraPrice: 0 },
      { name: 'L', extraPrice: 5000 },
    ],

    sugarLevels: [
      { name: '0%', extraPrice: 0 },
      { name: '50%', extraPrice: 0 },
      { name: '100%', extraPrice: 0 },
    ],

    iceLevels: [
      { name: 'Không đá', extraPrice: 0 },
      { name: 'Ít đá', extraPrice: 0 },
      { name: 'Bình thường', extraPrice: 0 },
    ],

    toppings: [
      { name: 'Đào', extraPrice: 5000 },
      { name: 'Thạch', extraPrice: 5000 },
    ],
  },

  {
    name: 'Trà Sữa Matcha',
    description: 'Trà sữa matcha thơm đậm vị.',
    price: 42000,
    imageUrl: '',
    category: 'Trà sữa',
    isAvailable: true,

    sizes: [
      { name: 'M', extraPrice: 0 },
      { name: 'L', extraPrice: 5000 },
    ],

    sugarLevels: [
      { name: '0%', extraPrice: 0 },
      { name: '50%', extraPrice: 0 },
      { name: '100%', extraPrice: 0 },
    ],

    iceLevels: [
      { name: 'Không đá', extraPrice: 0 },
      { name: 'Ít đá', extraPrice: 0 },
      { name: 'Bình thường', extraPrice: 0 },
    ],

    toppings: [
      { name: 'Trân châu', extraPrice: 5000 },
      { name: 'Thạch', extraPrice: 5000 },
    ],
  },

  {
    name: 'Hồng Trà Kem Cheese',
    description: 'Hồng trà kết hợp lớp kem cheese béo mịn.',
    price: 45000,
    imageUrl: '',
    category: 'Trà',
    isAvailable: true,

    sizes: [
      { name: 'M', extraPrice: 0 },
      { name: 'L', extraPrice: 5000 },
    ],

    sugarLevels: [
      { name: '0%', extraPrice: 0 },
      { name: '50%', extraPrice: 0 },
      { name: '100%', extraPrice: 0 },
    ],

    iceLevels: [
      { name: 'Không đá', extraPrice: 0 },
      { name: 'Ít đá', extraPrice: 0 },
      { name: 'Bình thường', extraPrice: 0 },
    ],

    toppings: [
      { name: 'Trân châu', extraPrice: 5000 },
      { name: 'Thạch', extraPrice: 5000 },
    ],
  },
];

async function seedProducts() {
  try {
    await mongoose.connect(process.env.MONGODB_URI);

    console.log('MongoDB connected');

    await Product.deleteMany({});

    await Product.insertMany(products);

    console.log('Products seeded successfully');

    await mongoose.disconnect();
  } catch (error) {
    console.error('Seed failed:', error);
    process.exit(1);
  }
}

seedProducts();