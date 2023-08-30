import fetch from 'cross-fetch';

export const myFetch = async (endpoint) => {
  const url = `https://sync-estoque.onrender.com/${endpoint}`;
  const response = await fetch(url);
  const result = await response.json();
  return result;
}