<template>
  <div class="container py-8">
    <el-breadcrumb separator="/" class="mb-6">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item>营销活动</el-breadcrumb-item>
    </el-breadcrumb>
    
    <div class="card mb-8">
      <div class="p-6">
        <h1 class="text-2xl font-bold mb-2">限时优惠活动</h1>
        <p class="text-neutral-medium">精选优惠活动，限时抢购，错过不再</p>
      </div>
    </div>
    
    <!-- 优惠券专区 -->
    <div class="mb-12">
      <div class="flex justify-between items-center mb-6">
        <h2 class="section-title mb-0">优惠券专区</h2>
        <router-link to="/user?tab=coupons" class="text-primary-accent hover:underline">查看我的优惠券</router-link>
      </div>
      
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div 
          v-for="coupon in coupons" 
          :key="coupon.id"
          class="card relative overflow-hidden"
        >
          <div class="p-6">
            <div class="flex justify-between items-start mb-4">
              <div>
                <div class="text-3xl font-bold text-primary-accent mb-1">¥{{ coupon.amount }}</div>
                <div class="text-neutral-medium">满{{ coupon.minAmount }}可用</div>
              </div>
              <el-tag type="success">{{ coupon.type }}</el-tag>
            </div>
            
            <h3 class="font-bold text-lg mb-2">{{ coupon.name }}</h3>
            <p class="text-neutral-medium text-sm mb-4">{{ coupon.description }}</p>
            
            <div class="flex justify-between items-center">
              <div class="text-sm text-neutral-medium">
                <p>有效期至 {{ coupon.expiryDate }}</p>
                <p>{{ coupon.usage }}/{{ coupon.total }} 已领取</p>
              </div>
              <el-button 
                type="primary" 
                :disabled="coupon.status !== 'available'"
                @click="claimCoupon(coupon)"
              >
                {{ coupon.status === 'available' ? '立即领取' : coupon.status === 'claimed' ? '已领取' : '已抢光' }}
              </el-button>
            </div>
          </div>
          
          <div class="absolute top-4 right-4 w-20 h-20 rounded-full bg-primary-accent/10 flex items-center justify-center">
            <el-icon :size="30" color="#34C759"><Ticket /></el-icon>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 满减活动 -->
    <div class="mb-12">
      <h2 class="section-title">满减活动</h2>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div 
          v-for="promotion in promotions" 
          :key="promotion.id"
          class="card p-6"
        >
          <div class="flex items-start">
            <div class="bg-surface rounded-lg p-3 mr-4">
              <el-icon :size="30" color="#FF9500"><Discount /></el-icon>
            </div>
            <div class="flex-1">
              <h3 class="font-bold text-lg mb-2">{{ promotion.title }}</h3>
              <p class="text-neutral-medium mb-3">{{ promotion.description }}</p>
              <div class="bg-surface rounded-lg p-3 mb-4">
                <p class="font-medium">{{ promotion.rule }}</p>
              </div>
              <p class="text-sm text-neutral-medium">活动时间: {{ promotion.period }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 推荐商品 -->
    <div>
      <div class="flex justify-between items-center mb-6">
        <h2 class="section-title mb-0">推荐商品</h2>
        <router-link to="/products" class="text-primary-accent hover:underline">查看更多</router-link>
      </div>
      
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        <ProductCard 
          v-for="product in recommendedProducts" 
          :key="product.id"
          :product="product"
          @view-details="goToProduct"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { Ticket, Discount } from '@element-plus/icons-vue'
import ProductCard from '../components/ProductCard.vue'
import { supabase } from '../supabaseClient'

const router = useRouter()

// 优惠券数据
const coupons = ref([
  {
    id: 1,
    name: '新人专享券',
    amount: 10,
    minAmount: 29,
    type: '满减券',
    description: '新用户专享，无门槛使用',
    expiryDate: '2025-12-31',
    usage: 1234,
    total: 5000,
    status: 'available' // available, claimed, exhausted
  },
  {
    id: 2,
    name: '品类专享券',
    amount: 30,
    minAmount: 99,
    type: '满减券',
    description: '适用于水果类商品',
    expiryDate: '2025-11-30',
    usage: 892,
    total: 2000,
    status: 'available'
  },
  {
    id: 3,
    name: '大促狂欢券',
    amount: 80,
    minAmount: 299,
    type: '满减券',
    description: '全场通用，限时抢购',
    expiryDate: '2025-11-15',
    usage: 1950,
    total: 2000,
    status: 'available'
  }
])

// 满减活动数据
const promotions = ref([
  {
    id: 1,
    title: '秋季大促',
    description: '精选时令果蔬，品质保证',
    rule: '满199减30，满399减80，满699减150',
    period: '2025.10.20 - 2025.11.10'
  },
  {
    id: 2,
    title: '会员专享',
    description: '黄金会员及以上等级专享',
    rule: '满159减20，满299减50，可与优惠券叠加',
    period: '长期有效'
  }
])

// 推荐商品数据
const recommendedProducts = ref([])

// 从数据库获取推荐商品
const fetchRecommendedProducts = async () => {
  try {
    const { data, error } = await supabase
      .from('products_46935')
      .select('*')
      .order('sales', { ascending: false })
      .limit(4)
      
    if (error) throw error
    
    // 转换数据格式
    recommendedProducts.value = data.map(product => ({
      id: product.id,
      name: product.name,
      price: parseFloat(product.price),
      originalPrice: product.original_price ? parseFloat(product.original_price) : null,
      image: product.images && product.images.length > 0 ? product.images[0] : '',
      rating: product.rating ? parseFloat(product.rating) : 0,
      sales: product.sales || 0
    }))
  } catch (error) {
    console.error('获取推荐商品失败:', error)
    // 出错时使用模拟数据
    recommendedProducts.value = [
      {
        id: 1,
        name: '有机苹果',
        price: 29.9,
        originalPrice: 39.9,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,apple&width=300&height=300&random=apple_marketing_300_300',
        rating: 4.8,
        sales: 1234
      },
      {
        id: 3,
        name: '农家土鸡蛋',
        price: 32.5,
        originalPrice: 38.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,eggs&width=300&height=300&random=eggs_marketing_300_300',
        rating: 4.9,
        sales: 2105
      },
      {
        id: 6,
        name: '海南芒果',
        price: 36.8,
        originalPrice: 45.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=mango&width=300&height=300&random=mango_marketing_300_300',
        rating: 4.7,
        sales: 923
      },
      {
        id: 4,
        name: '东北大米',
        price: 45.0,
        originalPrice: 52.0,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=northeast,rice&width=300&height=300&random=rice_marketing_300_300',
        rating: 4.6,
        sales: 1567
      }
    ]
  }
}

// 领取优惠券
const claimCoupon = (coupon) => {
  if (coupon.status === 'available') {
    // 模拟领取优惠券
    console.log('领取优惠券:', coupon.id)
    coupon.status = 'claimed'
    coupon.usage += 1
    alert(`成功领取 ${coupon.name}`)
  }
}

// 跳转到商品详情
const goToProduct = (productId) => {
  router.push(`/product/${productId}`)
}

onMounted(() => {
  fetchRecommendedProducts()
})
</script>
