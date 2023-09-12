import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import '../styles/Login.css'
import { myFetch } from '../services/fetch';

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
            const requestOptions = {
              method: 'POST',
              headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
              body: new URLSearchParams({ username, password }).toString()
            };
            
            const response = await myFetch('user/login', requestOptions);
            if (response.status == 200) {
              const result = await response.json();
              localStorage.setItem('token', result.access_token);
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
