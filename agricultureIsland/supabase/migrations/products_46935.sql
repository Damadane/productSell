/*
  # Create products table

  1. New Tables
    - `products_46935`
      - `id` (primary key, uuid)
      - `name` (text, not null)
      - `description` (text)
      - `price` (numeric, not null)
      - `original_price` (numeric)
      - `category` (text)
      - `stock` (integer, not null)
      - `origin` (text)
      - `specification` (text)
      - `rating` (numeric)
      - `sales` (integer)
      - `images` (text array)
      - `created_at` (timestamp with time zone, default now)
*/

CREATE TABLE IF NOT EXISTS products_46935 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  description text,
  price numeric NOT NULL,
  original_price numeric,
  category text,
  stock integer NOT NULL DEFAULT 0,
  origin text,
  specification text,
  rating numeric DEFAULT 0,
  sales integer DEFAULT 0,
  images text[],
  created_at timestamptz DEFAULT now()
);
