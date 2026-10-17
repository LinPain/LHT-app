const mongoose = require('mongoose');

const productOptionSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },
    extraPrice: {
      type: Number,
      default: 0,
      min: 0,
    },
  },
  { _id: false },
);

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
    },

    description: {
      type: String,
      default: '',
    },

    price: {
      type: Number,
      required: true,
      min: 0,
    },

    imageUrl: {
      type: String,
      default: '',
    },

    category: {
      type: String,
      required: true,
      trim: true,
    },

    isAvailable: {
      type: Boolean,
      default: true,
    },

    sizes: {
      type: [productOptionSchema],
      default: [],
    },

    sugarLevels: {
      type: [productOptionSchema],
      default: [],
    },

    iceLevels: {
      type: [productOptionSchema],
      default: [],
    },

    toppings: {
      type: [productOptionSchema],
      default: [],
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model('Product', productSchema);