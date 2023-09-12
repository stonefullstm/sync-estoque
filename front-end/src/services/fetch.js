import fetch from 'cross-fetch';

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