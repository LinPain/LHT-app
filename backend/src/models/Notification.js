const mongoose = require('mongoose');
const notificationSchema = new mongoose.Schema({
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'Customer', required: true, index: true },
  title: { type: String, required: true, trim: true },
  message: { type: String, required: true, trim: true },
  type: { type: String, enum: ['order', 'promo', 'system'], default: 'promo' },
  orderId: { type: String, default: '' },
  isRead: { type: Boolean, default: false },
}, { timestamps: true });
module.exports = mongoose.model('Notification', notificationSchema);
