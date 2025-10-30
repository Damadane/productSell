/*
  # 初始化农产品销售平台数据库结构

  1. 新增数据表
    - `products_47212`: 商品信息表
      - `id`: 主键，UUID类型
      - `name`: 商品名称，文本类型
      - `category`: 商品分类，文本类型
      - `price`: 价格，数值类型
      - `stock`: 库存数量，整数类型
      - `origin`: 产地，文本类型
      - `description`: 商品描述，文本类型
      - `image_url`: 商品图片链接，文本类型
      - `created_at`: 创建时间，时间戳类型
      - `updated_at`: 更新时间，时间戳类型

    - `orders_47212`: 订单信息表
      - `id`: 主键，UUID类型
      - `user_id`: 用户ID，UUID类型
      - `order_number`: 订单编号，文本类型
      - `total_amount`: 订单总金额，数值类型
      - `status`: 订单状态，文本类型
      - `created_at`: 创建时间，时间戳类型
      - `updated_at`: 更新时间，时间戳类型

    - `users_47212`: 用户信息表
      - `id`: 主键，UUID类型
      - `name`: 用户姓名，文本类型
      - `phone`: 手机号，文本类型
      - `email`: 邮箱，文本类型
      - `role`: 用户角色，文本类型
      - `created_at`: 创建时间，时间戳类型
      - `updated_at`: 更新时间，时间戳类型

    - `logistics_47212`: 物流信息表
      - `id`: 主键，UUID类型
      - `order_id`: 订单ID，UUID类型
      - `carrier`: 物流公司，文本类型
      - `tracking_number`: 物流单号，文本类型
      - `status`: 物流状态，文本类型
      - `sender`: 发货人，文本类型
      - `receiver`: 收货人，文本类型
      - `created_at`: 创建时间，时间戳类型
      - `updated_at`: 更新时间，时间戳类型
*/

CREATE TABLE IF NOT EXISTS products_47212 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  category TEXT,
  price DECIMAL(10, 2),
  stock INTEGER,
  origin TEXT,
  description TEXT,
  image_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS orders_47212 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID,
  order_number TEXT NOT NULL,
  total_amount DECIMAL(10, 2),
  status TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS users_47212 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  phone TEXT,
  email TEXT,
  role TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS logistics_47212 (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID,
  carrier TEXT,
  tracking_number TEXT,
  status TEXT,
  sender TEXT,
  receiver TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
