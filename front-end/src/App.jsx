import { BrowserRouter, Route, Routes } from 'react-router-dom';
import ProductsView from './pages/ProductsView';

export default function App() {
  return (
 
    <BrowserRouter>
    <Routes>
      <Route exact path="/" element={ <ProductsView /> } />
    </Routes>
    </BrowserRouter> 

  )
}