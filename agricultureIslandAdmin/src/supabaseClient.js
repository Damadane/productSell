import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://www.weavefox.cn/api/open/v1/supabase_proxy/363'
const supabaseAnonKey = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJvbGUiOiJhbm9uIiwiaWF0IjoxNzYxNTMxNzEzLCJleHAiOjEzMjcyMTcxNzEzfQ.Km1riN_uz0UDSOxmtU7hSp0a7gHK8BEeoLw4iMs5wBE'

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    persistSession: false,
    autoRefreshToken: false
  },
  db: {
    retryAttempts: 3,
    retryInterval: 1000
  }
})
