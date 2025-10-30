<template>
  <div>
    <!-- Banner 轮播图 -->
    <div class="relative bg-surface rounded-xl overflow-hidden my-6 mx-4">
      <div class="relative h-64 md:h-96">
        <img 
          src="https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,vegetables,fresh&width=1200&height=400&random=banner_1200_400" 
          alt="时令鲜蔬" 
          class="w-full h-full object-cover"
        >
        <div class="absolute inset-0 bg-gradient-to-r from-black/60 to-transparent"></div>
        <div class="absolute left-8 bottom-8 text-white max-w-md">
          <h2 class="text-2xl md:text-4xl font-bold mb-2">时令鲜果，产地直发</h2>
          <p class="mb-4">精选当季优质农产品，从田间到餐桌，新鲜直达</p>
          <button class="btn-primary">立即选购</button>
        </div>
      </div>
    </div>
    
    <div class="container">
      <!-- 商品分类导航 -->
      <section class="mb-12">
        <h2 class="section-title">商品分类</h2>
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <div 
            v-for="category in categories" 
            :key="category.id"
            class="bg-white rounded-xl p-6 text-center shadow-sm hover:shadow-md transition-shadow cursor-pointer"
            @click="goToCategory(category.id)"
          >
            <div class="bg-surface w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
              <img :src="category.icon" :alt="category.name" class="w-8 h-8">
            </div>
            <h3 class="font-medium">{{ category.name }}</h3>
          </div>
        </div>
      </section>
      
      <!-- 热销推荐 -->
      <section class="mb-12">
        <div class="flex justify-between items-center mb-6">
          <h2 class="section-title mb-0">热销推荐</h2>
          <router-link to="/products" class="text-primary-accent hover:underline">查看更多</router-link>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <ProductCard 
            v-for="product in featuredProducts" 
            :key="product.id"
            :product="product"
            @view-details="goToProduct"
          />
        </div>
      </section>
      
      <!-- 营销活动 -->
      <section class="mb-12">
        <h2 class="section-title">限时优惠</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="card bg-gradient-to-r from-primary-accent to-support-accent text-white p-8">
            <h3 class="text-2xl font-bold mb-2">满减优惠</h3>
            <p class="mb-4">满199减30，满399减80</p>
            <button class="bg-white text-primary-accent font-bold py-2 px-6 rounded-lg">立即抢购</button>
          </div>
          
          <div class="card relative overflow-hidden">
            <img 
              src="https://www.weavefox.cn/api/bolt/unsplash_image?keyword=coupon,discount&width=600&height=200&random=coupon_600_200" 
              alt="优惠券" 
              class="w-full h-40 object-cover"
            >
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent"></div>
            <div class="absolute bottom-4 left-4 text-white">
              <h3 class="text-xl font-bold">新人专享</h3>
              <p>无门槛10元优惠券</p>
            </div>
            <button class="absolute top-4 right-4 bg-white text-primary-accent font-bold py-1 px-3 rounded">立即领取</button>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import ProductCard from '../components/ProductCard.vue'
import { supabase } from '../supabaseClient'

const router = useRouter()

// 商品分类数据
const categories = ref([
  { id: 1, name: '新鲜蔬菜', icon: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=vegetable,icon&width=32&height=32&random=vegetable_32_32' },
  { id: 2, name: '精选水果', icon: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=fruit,icon&width=32&height=32&random=fruit_32_32' },
  { id: 3, name: '禽蛋肉类', icon: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=egg,meat,icon&width=32&height=32&random=meat_32_32' },
  { id: 4, name: '米面粮油', icon: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=grain,icon&width=32&height=32&random=grain_32_32' }
])

// 热销商品数据
const featuredProducts = ref([])

// 从数据库获取热销商品
const fetchFeaturedProducts = async () => {
  try {
    const { data, error } = await supabase
      .from('products_46935')
      .select('*')
      .order('sales', { ascending: false })
      .limit(4)
      
    if (error) throw error
    
    // 转换数据格式以匹配前端组件
    featuredProducts.value = data.map(product => ({
      id: product.id,
      name: product.name,
      price: parseFloat(product.price),
      originalPrice: product.original_price ? parseFloat(product.original_price) : null,
      image: product.images && product.images.length > 0 ? product.images[0] : '',
      rating: product.rating ? parseFloat(product.rating) : 0,
      sales: product.sales || 0
    }))
  } catch (error) {
    console.error('获取热销商品失败:', error)
    // 出错时使用模拟数据
    featuredProducts.value = [
      {
        id: 1,
        name: '有机苹果',
        price: 29.9,
        originalPrice: 39.9,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,apple&width=300&height=300&random=apple_300_300',
        rating: 4.8,
        sales: 1234
      },
      {
        id: 2,
        name: '新鲜菠菜',
        price: 12.8,
        originalPrice: 16.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=fresh,spinach&width=300&height=300&random=spinach_300_300',
        rating: 4.7,
        sales: 892
      },
      {
        id: 3,
        name: '农家土鸡蛋',
        price: 32.5,
        originalPrice: 38.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,eggs&width=300&height=300&random=eggs_300_300',
        rating: 4.9,
        sales: 2105
      },
      {
        id: 4,
        name: '东北大米',
        price: 45.0,
        originalPrice: 52.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=northeast,rice&width=300&height=300&random=rice_300_300',
        rating: 4.6,
        sales: 1567
      }
    ]
  }
}

const goToCategory = (categoryId) => {
  router.push(`/products?category=${categoryId}`)
}

const goToProduct = (productId) => {
  router.push(`/product/${productId}`)
}

onMounted(() => {
  fetchFeaturedProducts()
})
</script>
