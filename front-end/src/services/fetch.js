import fetch from 'cross-fetch';
import axios from 'axios';

export const myFetch = async (endpoint, options = null) => {
  const url = `https://sync-estoque.onrender.com/${endpoint}`;
  let response;
  if (!options)
    response = await fetch(url);
  else
    response = await fetch(url, options);
  // const result = await response.json();
  // return result;
  return response;
}

export const axiosApi = axios.create({
  baseURL: 'https://sync-estoque.onrender.com/estoque',
});

axiosApi.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);


axiosApi.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    if (error.response.status === 401 && !originalRequest._retry) {
      originalRequest._retry = true;

      try {
        const refreshToken = localStorage.getItem('refreshToken');
        const response = await axios.post('https://sync-estoque.onrender.com/refresh', { refreshToken });
        const { access_token } = response.data;

        localStorage.setItem('token', access_token);

        originalRequest.headers.Authorization = `Bearer ${access_token}`;
        return axios(originalRequest);
      } catch (error) {
        // Handle refresh token error or redirect to login
      }
    }

    return Promise.reject(error);
  }
);

