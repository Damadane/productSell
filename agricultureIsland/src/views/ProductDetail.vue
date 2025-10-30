<template>
  <div class="container py-8">
    <el-breadcrumb separator="/" class="mb-6">
      <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
      <el-breadcrumb-item :to="{ path: '/products' }">商品中心</el-breadcrumb-item>
      <el-breadcrumb-item>商品详情</el-breadcrumb-item>
    </el-breadcrumb>
    
    <div v-if="loading" class="text-center py-12">
      <el-skeleton :rows="10" animated />
    </div>
    
    <div v-else-if="product" class="card mb-8">
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8 p-6">
        <!-- 商品图片展示 -->
        <div>
          <div class="bg-surface rounded-lg overflow-hidden mb-4">
            <img 
              :src="currentImage" 
              :alt="product.name" 
              class="w-full h-96 object-contain"
            >
          </div>
          <div class="grid grid-cols-4 gap-2">
            <div 
              v-for="(image, index) in product.images" 
              :key="index"
              class="bg-surface rounded-lg overflow-hidden cursor-pointer border-2"
              :class="{ 'border-primary-accent': currentImageIndex === index }"
              @click="switchImage(index)"
            >
              <img :src="image" :alt="`${product.name} ${index + 1}`" class="w-full h-20 object-cover">
            </div>
          </div>
        </div>
        
        <!-- 商品信息与购买 -->
        <div>
          <h1 class="text-2xl font-bold mb-2">{{ product.name }}</h1>
          <div class="flex items-center mb-4">
            <el-rate
              v-model="product.rating"
              disabled
              :max="5"
            />
            <span class="text-neutral-medium ml-2">{{ product.rating }} ({{ product.reviews }}条评论)</span>
          </div>
          
          <div class="mb-6">
            <p class="text-3xl font-bold text-primary-accent mb-2">¥{{ product.price }}</p>
            <p v-if="product.originalPrice" class="text-neutral-medium line-through">原价: ¥{{ product.originalPrice }}</p>
          </div>
          
          <div class="mb-6">
            <p class="mb-2"><span class="text-neutral-medium">产地:</span> {{ product.origin }}</p>
            <p class="mb-2"><span class="text-neutral-medium">规格:</span> {{ product.specification }}</p>
            <p class="mb-2"><span class="text-neutral-medium">库存:</span> {{ product.stock }} 件</p>
          </div>
          
          <div class="mb-6">
            <p class="font-medium mb-2">数量</p>
            <el-input-number v-model="quantity" :min="1" :max="product.stock" size="large" />
          </div>
          
          <div class="flex space-x-4">
            <button class="btn-secondary flex-1 py-3 flex items-center justify-center">
              <el-icon class="mr-2"><Star /></el-icon>
              收藏商品
            </button>
            <button class="btn-primary flex-1 py-3 flex items-center justify-center" @click="addToCart">
              <el-icon class="mr-2"><ShoppingCart /></el-icon>
              加入购物车
            </button>
            <button class="btn-primary flex-1 py-3 bg-support-accent hover:bg-orange-500" @click="buyNow">
              立即购买
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <div v-if="product" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
      <!-- 商品详情 -->
      <div class="lg:col-span-2">
        <div class="card mb-8">
          <div class="border-b border-surface p-6">
            <h2 class="text-xl font-bold">商品详情</h2>
          </div>
          <div class="p-6">
            <div class="prose max-w-none">
              <p>{{ product.description }}</p>
              <img 
                :src="product.detailImage" 
                :alt="product.name + '详情'" 
                class="w-full my-4 rounded-lg"
              >
              <h3 class="font-bold mt-6 mb-3">产品特点</h3>
              <ul class="list-disc pl-5 space-y-2">
                <li>有机种植，无农药残留</li>
                <li>新鲜采摘，保证最佳口感</li>
                <li>严格质检，安全放心</li>
                <li>产地直发，冷链运输</li>
              </ul>
              <h3 class="font-bold mt-6 mb-3">营养价值</h3>
              <p>富含维生素C、膳食纤维和多种矿物质，有助于增强免疫力，促进消化。</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 用户评价 -->
      <div>
        <div class="card mb-8">
          <div class="border-b border-surface p-6">
            <h2 class="text-xl font-bold">用户评价 ({{ product.reviews }})</h2>
          </div>
          <div class="p-6">
            <div class="flex items-center mb-4">
              <span class="text-3xl font-bold mr-4">{{ product.rating }}</span>
              <div>
                <el-rate
                  v-model="product.rating"
                  disabled
                  :max="5"
                  size="large"
                />
                <p class="text-neutral-medium text-sm mt-1">{{ product.reviews }}条评论</p>
              </div>
            </div>
            
            <div class="space-y-6">
              <div 
                v-for="review in product.reviewList" 
                :key="review.id"
                class="border-b border-surface pb-6 last:border-0 last:pb-0"
              >
                <div class="flex items-center mb-2">
                  <img :src="review.avatar" :alt="review.user" class="w-10 h-10 rounded-full mr-3">
                  <div>
                    <p class="font-medium">{{ review.user }}</p>
                    <el-rate
                      v-model="review.rating"
                      disabled
                      size="small"
                      :max="5"
                    />
                  </div>
                </div>
                <p class="text-neutral-medium mb-2">{{ review.date }}</p>
                <p>{{ review.content }}</p>
              </div>
            </div>
            
            <button class="btn-secondary w-full mt-6">查看更多评价</button>
          </div>
        </div>
        
        <!-- 推荐商品 -->
        <div class="card">
          <div class="border-b border-surface p-6">
            <h2 class="text-xl font-bold">推荐商品</h2>
          </div>
          <div class="p-6">
            <div class="space-y-4">
              <div 
                v-for="item in relatedProducts" 
                :key="item.id"
                class="flex items-center cursor-pointer group"
                @click="goToProduct(item.id)"
              >
                <img :src="item.image" :alt="item.name" class="w-16 h-16 object-cover rounded">
                <div class="ml-3">
                  <h4 class="text-sm font-medium group-hover:text-primary-accent transition-colors">{{ item.name }}</h4>
                  <p class="text-primary-accent font-bold">¥{{ item.price }}</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Star, ShoppingCart } from '@element-plus/icons-vue'
import { supabase } from '../supabaseClient'

const route = useRoute()
const router = useRouter()
const productId = route.params.id

// 状态
const loading = ref(false)

// 当前选中的图片索引
const currentImageIndex = ref(0)

// 购买数量
const quantity = ref(1)

// 商品数据
const product = ref(null)

// 相关商品（推荐）
const relatedProducts = ref([])

// 当前显示的图片
const currentImage = computed(() => {
  return product.value && product.value.images && product.value.images.length > 0 
    ? product.value.images[currentImageIndex.value] 
    : ''
})

// 切换图片
const switchImage = (index) => {
  currentImageIndex.value = index
}

// 从数据库获取商品详情
const fetchProductDetail = async () => {
  loading.value = true
  try {
    const { data, error } = await supabase
      .from('products_46935')
      .select('*')
      .eq('id', productId)
      .single()
      
    if (error) throw error
    
    // 转换数据格式
    product.value = {
      id: data.id,
      name: data.name,
      price: parseFloat(data.price),
      originalPrice: data.original_price ? parseFloat(data.original_price) : null,
      rating: data.rating ? parseFloat(data.rating) : 0,
      reviews: 128, // 模拟数据
      origin: data.origin || '未知',
      specification: data.specification || '标准规格',
      stock: data.stock || 0,
      description: data.description || '暂无商品描述',
      images: data.images || [],
      detailImage: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple,nutrition&width=800&height=400&random=apple_nutrition_800_400',
      reviewList: [
        {
          id: 1,
          user: '张女士',
          avatar: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=woman,avatar&width=100&height=100&random=woman_avatar_100_100',
          rating: 5,
          date: '2025-10-25',
          content: '苹果很新鲜，口感很好，包装也很用心，非常满意的一次购物体验！'
        },
        {
          id: 2,
          user: '李先生',
          avatar: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=man,avatar&width=100&height=100&random=man_avatar_100_100',
          rating: 4,
          date: '2025-10-20',
          content: '苹果确实很甜，比我之前在超市买的要好很多，就是有点小贵。'
        }
      ]
    }
    
    // 获取相关商品（同分类的其他商品）
    await fetchRelatedProducts(data.category)
  } catch (error) {
    console.error('获取商品详情失败:', error)
    // 出错时使用模拟数据
    product.value = {
      id: productId,
      name: '有机苹果',
      price: 29.9,
      originalPrice: 39.9,
      rating: 4.8,
      reviews: 128,
      origin: '山东烟台',
      specification: '5斤装',
      stock: 156,
      description: '我们的有机苹果产自山东烟台，这里光照充足，昼夜温差大，特别适合苹果生长。果园采用有机种植方式，不使用任何化学农药和化肥，确保每一颗苹果都健康安全。苹果色泽鲜艳，口感脆甜，营养丰富，是您健康生活的理想选择。',
      images: [
        'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,apple&width=500&height=500&random=apple_detail_500_500',
        'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple,slice&width=500&height=500&random=apple_slice_500_500',
        'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple,tree&width=500&height=500&random=apple_tree_500_500',
        'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=organic,farm&width=500&height=500&random=organic_farm_500_500'
      ],
      detailImage: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=apple,nutrition&width=800&height=400&random=apple_nutrition_800_400',
      reviewList: [
        {
          id: 1,
          user: '张女士',
          avatar: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=woman,avatar&width=100&height=100&random=woman_avatar_100_100',
          rating: 5,
          date: '2025-10-25',
          content: '苹果很新鲜，口感很好，包装也很用心，非常满意的一次购物体验！'
        },
        {
          id: 2,
          user: '李先生',
          avatar: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=man,avatar&width=100&height=100&random=man_avatar_100_100',
          rating: 4,
          date: '2025-10-20',
          content: '苹果确实很甜，比我之前在超市买的要好很多，就是有点小贵。'
        }
      ]
    }
    
    relatedProducts.value = [
      {
        id: 2,
        name: '新鲜菠菜',
        price: 12.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=fresh,spinach&width=100&height=100&random=spinach_related_100_100'
      },
      {
        id: 3,
        name: '农家土鸡蛋',
        price: 32.5,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,eggs&width=100&height=100&random=eggs_related_100_100'
      },
      {
        id: 6,
        name: '海南芒果',
        price: 36.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=mango&width=100&height=100&random=mango_related_100_100'
      }
    ]
  } finally {
    loading.value = false
  }
}

// 获取相关商品
const fetchRelatedProducts = async (category) => {
  try {
    const { data, error } = await supabase
      .from('products_46935')
      .select('*')
      .eq('category', category)
      .neq('id', productId)
      .limit(3)
      
    if (error) throw error
    
    // 转换数据格式
    relatedProducts.value = data.map(item => ({
      id: item.id,
      name: item.name,
      price: parseFloat(item.price),
      image: item.images && item.images.length > 0 ? item.images[0] : ''
    }))
  } catch (error) {
    console.error('获取相关商品失败:', error)
    // 出错时使用模拟数据
    relatedProducts.value = [
      {
        id: 2,
        name: '新鲜菠菜',
        price: 12.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=fresh,spinach&width=100&height=100&random=spinach_related_100_100'
      },
      {
        id: 3,
        name: '农家土鸡蛋',
        price: 32.5,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=farm,eggs&width=100&height=100&random=eggs_related_100_100'
      },
      {
        id: 6,
        name: '海南芒果',
        price: 36.8,
        image: 'https://www.weavefox.cn/api/bolt/unsplash_image?keyword=mango&width=100&height=100&random=mango_related_100_100'
      }
    ]
  }
}

// 加入购物车
const addToCart = () => {
  // 这里应该调用API将商品添加到购物车
  console.log(`将 ${quantity.value} 件商品添加到购物车`)
  alert(`已将 ${quantity.value} 件${product.value.name}添加到购物车`)
}

// 立即购买
const buyNow = () => {
  // 这里应该跳转到订单确认页面
  console.log(`立即购买 ${quantity.value} 件商品`)
  router.push('/orders')
}

// 跳转到商品详情
const goToProduct = (id) => {
  router.push(`/product/${id}`)
}

onMounted(() => {
  fetchProductDetail()
})
</script>
