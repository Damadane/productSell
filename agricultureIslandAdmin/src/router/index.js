import { createRouter, createWebHashHistory } from 'vue-router'
import Layout from '../components/Layout.vue'

const routes = [
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: '/dashboard',
        name: 'Dashboard',
        component: () => import('../views/Dashboard.vue')
      },
      // 商品管理
      {
        path: '/products/list',
        name: 'ProductList',
        component: () => import('../views/products/ProductList.vue')
      },
      {
        path: '/products/categories',
        name: 'ProductCategories',
        component: () => import('../views/products/ProductCategories.vue')
      },
      {
        path: '/products/inventory',
        name: 'ProductInventory',
        component: () => import('../views/products/ProductInventory.vue')
      },
      // 订单管理
      {
        path: '/orders/list',
        name: 'OrderList',
        component: () => import('../views/orders/OrderList.vue')
      },
      {
        path: '/orders/refund',
        name: 'OrderRefund',
        component: () => import('../views/orders/OrderRefund.vue')
      },
      // 用户管理
      {
        path: '/users/list',
        name: 'UserList',
        component: () => import('../views/users/UserList.vue')
      },
      {
        path: '/users/merchants',
        name: 'MerchantList',
        component: () => import('../views/users/MerchantList.vue')
      },
      {
        path: '/users/delivery',
        name: 'DeliveryList',
        component: () => import('../views/users/DeliveryList.vue')
      },
      {
        path: '/users/members',
        name: 'MemberList',
        component: () => import('../views/users/MemberList.vue')
      },
      // 物流管理
      {
        path: '/logistics/list',
        name: 'LogisticsList',
        component: () => import('../views/logistics/LogisticsList.vue')
      },
      {
        path: '/logistics/carriers',
        name: 'CarrierList',
        component: () => import('../views/logistics/CarrierList.vue')
      },
      // 营销管理
      {
        path: '/marketing/coupons',
        name: 'CouponList',
        component: () => import('../views/marketing/CouponList.vue')
      },
      {
        path: '/marketing/promotions',
        name: 'PromotionList',
        component: () => import('../views/marketing/PromotionList.vue')
      },
      {
        path: '/marketing/recommendations',
        name: 'RecommendationList',
        component: () => import('../views/marketing/RecommendationList.vue')
      },
      // 系统设置
      {
        path: '/system',
        name: 'SystemSettings',
        component: () => import('../views/SystemSettings.vue')
      }
    ]
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
