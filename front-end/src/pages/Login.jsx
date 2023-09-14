import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import '../styles/Login.css'

function Login() {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const navigate = useNavigate();

  return (
    <>
      <div className='login'>  
        <h1 className='login-title'>User Login</h1>
        <input type='text'
          placeholder='Username'
          name='username'
          value={ username }
          onChange={ ({ target }) => setUsername(target.value)}
          className='email' />
        <input type='password'
          placeholder='Password'
          name='password'
          value={ password }
          onChange={ ({ target }) => setPassword(target.value)}
          className='password' />
        <button type='button'
          className='login-button'
          onClick={ async () => {
            const params = new URLSearchParams({ username, password });
            const response = await axios.post('https://sync-estoque.onrender.com/user/login', params);
            if (response.status == 200) {
              const result = await response.data;
              localStorage.setItem('token', result.access_token);
              localStorage.setItem('refreshToken', result.refresh_token);
              navigate('/products')
            } else {
              alert('Dados de login inválidos');
            }
          }}
        >
          Login
        </button>
      </div>
    </>
  )
}

export default Login;
