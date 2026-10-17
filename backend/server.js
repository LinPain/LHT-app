require('dotenv').config();

const express = require('express');
const cors = require('cors');

const connectDatabase = require('./src/config/database');
const productRoutes = require('./src/routes/productRoutes');
const mobileRoutes = require('./src/routes/mobileRoutes');

const app = express();

const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use('/api', mobileRoutes);
app.use('/api/products', productRoutes);

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Hồng Trà Lê Gia API is running',
  });
});

app.use('/api', (req, res) => {
  res.status(404).json({ success: false, error: 'Không tìm thấy API endpoint.', code: 'NOT_FOUND' });
});

app.use((error, req, res, next) => {
  console.error(error);
  if (res.headersSent) return next(error);
  const status = error.code === 11000 ? 409 : 500;
  res.status(status).json({ success: false, error: status === 409 ? 'Thông tin đã được sử dụng.' : 'Lỗi máy chủ.', code: status === 409 ? 'DUPLICATE_VALUE' : 'INTERNAL_ERROR' });
});

connectDatabase();

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
