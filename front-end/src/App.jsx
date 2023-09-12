import { BrowserRouter, Route, Routes } from 'react-router-dom';
import ProductsView from './pages/ProductsView';
import Login from './pages/Login';

export default function App() {
  return (
 
    <BrowserRouter>
    <Routes>
      <Route exact path="/" element={<Login />} />
      <Route exact path="/products" element={ <ProductsView /> } />
    </Routes>
    </BrowserRouter> 

  )
}