<template>
  <div class="container py-8">
    <div class="flex flex-col md:flex-row gap-8">
      <!-- 侧边栏筛选 -->
      <div class="md:w-1/4">
        <div class="card p-6 mb-6">
          <h3 class="font-bold text-lg mb-4">商品筛选</h3>
          
          <div class="mb-6">
            <h4 class="font-medium mb-3">价格区间</h4>
            <el-slider
              v-model="priceRange"
              range
              :min="0"
              :max="200"
              :step="10"
            />
            <div class="flex justify-between text-sm text-neutral-medium mt-2">
              <span>¥{{ priceRange[0] }}</span>
              <span>¥{{ priceRange[1] }}</span>
            </div>
          </div>
          
          <div class="mb-6">
            <h4 class="font-medium mb-3">商品分类</h4>
            <el-checkbox-group v-model="selectedCategories">
              <div class="flex flex-col space-y-2">
                <el-checkbox v-for="category in categories" :key="category.id" :label="category.id">
                  {{ category.name }}
                </el-checkbox>
              </div>
            </el-checkbox-group>
          </div>
          
          <el-button type="primary" class="w-full" @click="applyFilters">应用筛选</el-button>
        </div>
        
        <div class="card p-6">
          <h3 class="font-bold text-lg mb-4">热销商品</h3>
          <div class="space-y-4">
            <div 
              v-for="product in topSellingProducts" 
              :key="product.id"
              class="flex items-center cursor-pointer group"
              @click="goToProduct(product.id)"
            >
              <img :src="product.image" :alt="product.name" class="w-16 h-16 object-cover rounded">
              <div class="ml-3">
                <h4 class="text-sm font-medium group-hover:text-primary-accent transition-colors">{{ product.name }}</h4>
                <p class="text-primary-accent font-bold">¥{{ product.price }}</p>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 商品列表 -->
      <div class="md:w-3/4">
        <div class="flex justify-between items-center mb-6">
          <h1 class="text-2xl font-bold">所有商品</h1>
          <div class="flex items-center">
            <span class="text-neutral-medium mr-4">排序:</span>
            <el-select v-model="sortOption" class="w-40">
              <el-option label="默认排序" value="default" />
              <el-option label="价格从低到高" value="price-asc" />
              <el-option label="价格从高到低" value="price-desc" />
              <el-option label="销量最多" value="sales" />
              <el-option label="评分最高" value="rating" />
            </el-select>
          </div>
        </div>
        
        <div v-if="loading" class="text-center py-12">
          <el-skeleton :rows="4" animated />
        </div>
        
        <div v-else-if="filteredProducts.length === 0" class="text-center py-12">
          <el-empty description="暂无符合条件的商品" />
        </div>
        
        <div v-else>
          <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 mb-8">
            <ProductCard 
              v-for="product in filteredProducts" 
              :key="product.id"
              :product="product"
              @view-details="goToProduct"
            />
          </div>
          
          <div class="flex justify-center">
            <el-pagination
              v-model:current-page="currentPage"
              :page-size="pageSize"
              :total="totalProducts"
              layout="prev, pager, next"
              background
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import ProductCard from '../components/ProductCard.vue'
import { supabase } from '../supabaseClient'

const route = useRoute()
const router = useRouter()

// 状态
const loading = ref(false)

// 筛选状态
const priceRange = ref([0, 200])
const selectedCategories = ref([])
const sortOption = ref('default')
const currentPage = ref(1)
const pageSize = ref(9)

// 商品数据
const allProducts = ref([])
const topSellingProducts = ref([])

// 商品分类数据
const categories = ref([
  { id: 1, name: '新鲜蔬菜' },
  { id: 2, name: '精选水果' },
  { id: 3, name: '禽蛋肉类' },
  { id: 4, name: '米面粮油' },
  { id: 5, name: '干货特产' }
])

// 从数据库获取商品数据
const fetchProducts = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('products_46935')
      .select('*')
      
    if (error) throw error
    
    // 转换数据格式
    allProducts.value = data.map(product => ({
      id: product.id,
      name: product.name,
      price: parseFloat(product.price),
      originalPrice: product.original_price ? parseFloat(product.original_price) : null,
      image: product.images && product.images.length > 0 ? product.images[0] : '',
      rating: product.rating ? parseFloat(product.rating) : 0,
      sales: product.sales || 0,
      categoryId: product.category ? categories.value.findIndex(c => c.name === product.category) + 1 : 1
    }))
    
    // 设置热销商品（销量前3）
    topSellingProducts.value = [...allProducts.value]
      .sort((a, b) => b.sales - a.sales)
      .slice(0, 3)
  } catch (error) {
    console.error('获取商品数据失败:', error)
    // 出错时使用模拟数据
    allProducts.value = [
      {
        id: 1,
        name: '有机苹果',
        price: 29.9,
        originalPrice: 39.9,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,apple&width=300&height=300&random=apple_list_300_300',
        rating: 4.8,
        sales: 1234,
        categoryId: 2
      },
      {
        id: 2,
        name: '新鲜菠菜',
        price: 12.8,
        originalPrice: 16.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=fresh,spinach&width=300&height=300&random=spinach_list_300_300',
        rating: 4.7,
        sales: 892,
        categoryId: 1
      },
      {
        id: 3,
        name: '农家土鸡蛋',
        price: 32.5,
        originalPrice: 38.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,eggs&width=300&height=300&random=eggs_list_300_300',
        rating: 4.9,
        sales: 2105,
        categoryId: 3
      },
      {
        id: 4,
        name: '东北大米',
        price: 45.0,
        originalPrice: 52.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=northeast,rice&width=300&height=300&random=rice_list_300_300',
        rating: 4.6,
        sales: 1567,
        categoryId: 4
      },
      {
        id: 5,
        name: '新疆葡萄干',
        price: 28.0,
        originalPrice: 35.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=raisins&width=300&height=300&random=raisins_list_300_300',
        rating: 4.5,
        sales: 756,
        categoryId: 5
      },
      {
        id: 6,
        name: '海南芒果',
        price: 36.8,
        originalPrice: 45.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=mango&width=300&height=300&random=mango_list_300_300',
        rating: 4.7,
        sales: 923,
        categoryId: 2
      },
      {
        id: 7,
        name: '有机西兰花',
        price: 18.5,
        originalPrice: 24.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=broccoli&width=300&height=300&random=broccoli_list_300_300',
        rating: 4.6,
        sales: 642,
        categoryId: 1
      },
      {
        id: 8,
        name: '散养土鸡',
        price: 88.0,
        originalPrice: 108.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=chicken&width=300&height=300&random=chicken_list_300_300',
        rating: 4.8,
        sales: 432,
        categoryId: 3
      }
    ]
    
    topSellingProducts.value = [...allProducts.value]
      .sort((a, b) => b.sales - a.sales)
      .slice(0, 3)
  } finally {
    loading.value = false
  }
}

// 筛选后的商品
const filteredProducts = computed(() => {
  let result = [...allProducts.value]
  
  // 价格筛选
  result = result.filter(product => 
    product.price >= priceRange.value[0] && 
    product.price <= priceRange.value[1]
  )
  
  // 分类筛选
  if (selectedCategories.value.length > 0) {
    result = result.filter(product => 
      selectedCategories.value.includes(product.categoryId)
    )
  }
  
  // 排序
  switch (sortOption.value) {
    case 'price-asc':
      result.sort((a, b) => a.price - b.price)
      break
    case 'price-desc':
      result.sort((a, b) => b.price - a.price)
      break
    case 'sales':
      result.sort((a, b) => b.sales - a.sales)
      break
    case 'rating':
      result.sort((a, b) => b.rating - a.rating)
      break
    default:
      // 默认按ID排序
      result.sort((a, b) => a.id - b.id)
  }
  
  return result
})

// 总商品数
const totalProducts = computed(() => filteredProducts.value.length)

// 应用筛选
const applyFilters = () => {
  // 这里可以添加筛选逻辑，实际项目中可能需要调用API
  console.log('应用筛选:', {
    priceRange: priceRange.value,
    categories: selectedCategories.value,
    sort: sortOption.value
  })
}

// 跳转到商品详情
const goToProduct = (productId) => {
  router.push(`/product/${productId}`)
}

onMounted(() => {
  fetchProducts()
})
</script>
