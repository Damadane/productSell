/*
  # Create users table

  1. New Tables
    - `users_46935`
      - `id` (primary key, uuid)
      - `name` (text, not null)
      - `email` (text, not null, unique)
      - `phone` (text)
      - `gender` (text)
      - `birthday` (date)
      - `membership_level` (text)
      - `experience` (integer)
      - `points` (integer)
      - `addresses` (jsonb)
      - `created_at` (timestamp with time zone, default now)
*/

CREATE TABLE IF NOT EXISTS users_46935 (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  email text NOT NULL UNIQUE,
  phone text,
  gender text,
  birthday date,
  membership_level text,
  experience integer DEFAULT 0,
  points integer DEFAULT 0,
  addresses jsonb,
  created_at timestamptz DEFAULT now()
);
