import { createRouter, createWebHashHistory } from 'vue-router'
import Home from '../views/Home.vue'
import ProductList from '../views/ProductList.vue'
import ProductDetail from '../views/ProductDetail.vue'
import UserCenter from '../views/UserCenter.vue'
import OrderManagement from '../views/OrderManagement.vue'
import LogisticsTracking from '../views/LogisticsTracking.vue'
import MarketingActivities from '../views/MarketingActivities.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/products',
    name: 'ProductList',
    component: ProductList
  },
  {
    path: '/product/:id',
    name: 'ProductDetail',
    component: ProductDetail
  },
  {
    path: '/user',
    name: 'UserCenter',
    component: UserCenter
  },
  {
    path: '/orders',
    name: 'OrderManagement',
    component: OrderManagement
  },
  {
    path: '/logistics',
    name: 'LogisticsTracking',
    component: LogisticsTracking
  },
  {
    path: '/marketing',
    name: 'MarketingActivities',
    component: MarketingActivities
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
