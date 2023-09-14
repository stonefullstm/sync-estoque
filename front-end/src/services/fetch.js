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
