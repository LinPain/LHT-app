class OrderInputError extends Error {
  constructor(message, code) {
    super(message);
    this.name = 'OrderInputError';
    this.statusCode = 400;
    this.code = code;
  }
}

function normalizeOrderItems(items, products) {
  const productMap = new Map(products.map((product) => [String(product._id), product]));
  let subtotal = 0;
  const normalizedItems = [];

  for (const item of items) {
    const product = productMap.get(String(item.productId));
    if (!product) {
      throw new OrderInputError(
        `Sản phẩm không khả dụng: ${item.productName || item.productId}`,
        'PRODUCT_UNAVAILABLE',
      );
    }

    const quantity = Math.max(1, Math.min(99, Number(item.quantity) || 1));
    const customization = item.customization || {};
    const size = (product.sizes || []).find(
      (option) => option.name === customization.sizeId || option.code === customization.sizeId,
    );
    if ((product.sizes || []).length && !size) {
      throw new OrderInputError(`Vui lòng chọn size hợp lệ cho ${product.name}.`, 'INVALID_PRODUCT_OPTION');
    }

    const selectedOption = (options, id) => !id ? null : options.find(
      (option) => option.name === id || option.code === id,
    );
    const sugar = selectedOption(product.sugarLevels || [], customization.sugarLevelId);
    const ice = selectedOption(product.iceLevels || [], customization.iceLevelId);
    if ((customization.sugarLevelId && !sugar) || (customization.iceLevelId && !ice)) {
      throw new OrderInputError(`Tùy chọn đường hoặc đá không hợp lệ cho ${product.name}.`, 'INVALID_PRODUCT_OPTION');
    }

    const toppingIds = Array.isArray(customization.toppingIds) ? customization.toppingIds : [];
    const selectedToppings = (product.toppings || []).filter(
      (option) => toppingIds.includes(option.name) || toppingIds.includes(option.code),
    );
    if (selectedToppings.length !== new Set(toppingIds).size) {
      throw new OrderInputError(`Tùy chọn topping không hợp lệ cho ${product.name}.`, 'INVALID_PRODUCT_OPTION');
    }

    const unitPrice = product.price + (size?.extraPrice || 0) + (sugar?.extraPrice || 0) +
      (ice?.extraPrice || 0) + selectedToppings.reduce((sum, option) => sum + option.extraPrice, 0);
    const totalPrice = unitPrice * quantity;
    subtotal += totalPrice;
    normalizedItems.push({
      productId: product.id,
      productName: product.name,
      quantity,
      unitPrice,
      totalPrice,
      customization,
      size: size?.name || '',
    });
  }

  return { normalizedItems, subtotal };
}

module.exports = { normalizeOrderItems, OrderInputError };
