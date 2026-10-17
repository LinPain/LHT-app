const Product = require('../models/Product');

const getProducts = async (req, res) => {
  try {
    const filter = { isAvailable: true };
    if (req.query.category && req.query.category !== 'all') filter.category = req.query.category;
    if (req.query.categoryId && req.query.categoryId !== 'all') {
      const categories = await Product.distinct('category', { isAvailable: true });
      const category = categories.find((name, index) => `cat-${index + 1}` === req.query.categoryId || name === req.query.categoryId);
      if (!category) return res.json({ success: true, data: [] });
      filter.category = category;
    }
    if (req.query.search) filter.name = { $regex: String(req.query.search).trim(), $options: 'i' };
    const products = await Product.find(filter).sort({ createdAt: -1 });

    res.json({
      success: true,
      data: products,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to get products',
      error: error.message,
    });
  }
};

const getProductById = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);

    if (!product) {
      return res.status(404).json({
        success: false,
        message: 'Product not found',
      });
    }

    res.json({
      success: true,
      data: product,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Failed to get product',
      error: error.message,
    });
  }
};

module.exports = {
  getProducts,
  getProductById,
};
