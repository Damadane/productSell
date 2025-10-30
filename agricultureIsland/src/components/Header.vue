<template>
  <header class="bg-white shadow-sm sticky top-0 z-50">
    <div class="container py-4">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-10">
          <router-link to="/" class="flex items-center">
            <img src="https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,logo&width=40&height=40&random=logo_40_40" alt="农品优选" class="w-10 h-10 rounded-lg">
            <span class="ml-2 text-xl font-bold text-primary-text">农品优选</span>
          </router-link>
          
          <nav class="hidden md:flex space-x-8">
            <router-link to="/" class="text-primary-text hover:text-primary-accent font-medium">首页</router-link>
            <router-link to="/products" class="text-primary-text hover:text-primary-accent font-medium">商品</router-link>
            <router-link to="/marketing" class="text-primary-text hover:text-primary-accent font-medium">优惠活动</router-link>
            <router-link to="/logistics" class="text-primary-text hover:text-primary-accent font-medium">物流跟踪</router-link>
          </nav>
        </div>
        
        <div class="flex items-center space-x-4">
          <div class="relative">
            <el-input
              v-model="searchQuery"
              placeholder="搜索商品..."
              class="w-40 md:w-64"
              @keyup.enter="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
            <div v-if="showSuggestions && searchSuggestions.length > 0" class="absolute top-full left-0 right-0 bg-white shadow-lg rounded-lg mt-1 z-50">
              <div 
                v-for="suggestion in searchSuggestions" 
                :key="suggestion.id"
                class="px-4 py-2 hover:bg-surface cursor-pointer"
                @click="selectSuggestion(suggestion)"
              >
                {{ suggestion.name }}
              </div>
            </div>
          </div>
          
          <router-link to="/user" class="p-2 rounded-full hover:bg-surface">
            <el-icon :size="20"><User /></el-icon>
          </router-link>
          
          <div class="relative">
            <router-link to="/orders" class="p-2 rounded-full hover:bg-surface">
              <el-icon :size="20"><ShoppingCart /></el-icon>
            </router-link>
            <span v-if="cartCount > 0" class="absolute -top-1 -right-1 bg-primary-accent text-white text-xs rounded-full h-5 w-5 flex items-center justify-center">
              {{ cartCount }}
            </span>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { Search, User, ShoppingCart } from '@element-plus/icons-vue'

const router = useRouter()
const searchQuery = ref('')
const showSuggestions = ref(false)
const cartCount = ref(3)

// 模拟搜索建议数据
const allProducts = [
  { id: 1, name: '有机苹果', category: '水果' },
  { id: 2, name: '新鲜菠菜', category: '蔬菜' },
  { id: 3, name: '农家土鸡蛋', category: '禽蛋' },
  { id: 4, name: '东北大米', category: '粮油' },
  { id: 5, name: '有机西兰花', category: '蔬菜' },
  { id: 6, name: '新疆葡萄干', category: '干货' }
]

const searchSuggestions = ref([])

// 监听搜索框变化
watch(searchQuery, (newQuery) => {
  if (newQuery.trim() === '') {
    searchSuggestions.value = []
    showSuggestions.value = false
    return
  }
  
  // 模拟搜索建议
  searchSuggestions.value = allProducts.filter(product => 
    product.name.toLowerCase().includes(newQuery.toLowerCase())
  ).slice(0, 5)
  
  showSuggestions.value = searchSuggestions.value.length > 0
})

const handleSearch = () => {
  if (searchQuery.value.trim() !== '') {
    router.push(`/products?search=${encodeURIComponent(searchQuery.value)}`)
    showSuggestions.value = false
  }
}

const selectSuggestion = (suggestion) => {
  searchQuery.value = suggestion.name
  router.push(`/product/${suggestion.id}`)
  showSuggestions.value = false
}
</script>
