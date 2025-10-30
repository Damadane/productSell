/*
  # Create orders table

  1. New Tables
    - `orders_46935`
      - `id` (primary key, uuid)
      - `user_id` (uuid, not null, foreign key to users_46935.id)
      - `items` (jsonb, not null)
      - `total` (numeric, not null)
      - `status` (text, not null)
      - `tracking_number` (text)
      - `recipient` (text)
      - `address` (text)
      - `created_at` (timestamp with time zone, default now)
*/

CREATE TABLE IF NOT EXISTS orders_46935 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users_46935(id),
  items jsonb NOT NULL,
  total numeric NOT NULL,
  status text NOT NULL,
  tracking_number text,
  recipient text,
  address text,
  created_at timestamptz DEFAULT now()
);
