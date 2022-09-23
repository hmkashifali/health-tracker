import axios from 'axios'
import { mapKeys } from 'utils/helper_methods.coffee'
const VERSION = 'v1'
const API_ENDPOINT = 'api'
const BASE_URL = `http://localhost:3003/${API_ENDPOINT}/${VERSION}/`

const TOKEN = '0e4a765953abd408ab0e62e161b11216'
// const TOKEN = '11cd58402cc914c569231ec79a432311'
const axiosInstance = axios.create({
  baseURL: BASE_URL,
  headers: {
    Accept: 'application/json',
    Authorization: `Bearer ${TOKEN}`,
    'Content-Type': 'application/json'
  }
})
axiosInstance.interceptors.response.use(
  response => {
    console.log(response, response.data)
    response.data = mapKeys(response.data)
    return Promise.resolve(response)
  },
  error => {
    if (error.response.status) {
      switch (error.response.status) {
        case 400:

         //do something
          break;

        case 401:
          alert("Invalid Credentials");
          break;
        case 403:
          router.replace({
            path: "/login",
            query: { redirect: router.currentRoute.fullPath }
          });
           break;
        case 404:
          // alert('page not exist');
          break;
        case 502:
         setTimeout(() => {
            router.replace({
              path: "/login",
              query: {
                redirect: router.currentRoute.fullPath
              }
            });
          }, 1000);
      }
      return Promise.reject(error.response)
    }
  }
)
export default axiosInstance
