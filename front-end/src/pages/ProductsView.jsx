import { useState, useMemo } from "react";
import Pagination from "../components/Pagination";
import { axiosApi } from "../services/fetch";
import "../styles/ProductsView.css";

const PageSize = 10;

function ProductsView() {
  // const [account, setAccount] = useState('');
  const [initialDate, setInitialDate] = useState('');
  const [finalDate, setFinalDate] = useState('');
  // const [operador, setOperador] = useState('');
  const [products, setProducts] = useState();
  const [currentPage, setCurrentPage] = useState(1);

  const currentTableData = useMemo(() => {
    const firstPageIndex = (currentPage - 1) * PageSize;
    const lastPageIndex = firstPageIndex + PageSize;
    return products ? products.products.slice(firstPageIndex, lastPageIndex) : [];
  }, [currentPage, products]);

  return (
    <>
      <div>
        <h1 className="page_title">
          Consultas de Estoque
        </h1>
      </div>
      <div className="filter_form">
        {/* <label htmlFor="bank-account" className="bank_account">
          Fornecedor:
          <input
            className="input"
            data-testid="bank-account"
            type="number"
            value={ account }
            onChange={ ({ target }) => setAccount(target.value)}
          />
        </label> */}
        <div className="filters">
        <label htmlFor="initial-date">
          Fornecedor:
          <input
            className="input"
            data-testid="initial-date"
            type="text"
            value={ initialDate }
            onChange={ ({ target }) => setInitialDate(target.value)}
          />
        </label>
        <label htmlFor="final-date">
          Grupo:
          <input
            className="input"
            data-testid="final-date"
            type="text"
            value={ finalDate }
            onChange={ ({ target }) => setFinalDate(target.value)}
          />
        </label>
        {/* <label htmlFor="operador">
          Operador:
          <input
            className="input"
            data-testid="operador"
            type="text"
            value={ operador }
            onChange={ ({ target }) => setOperador(target.value)}
          />
        </label> */}
        <button
          type="button"
          onClick={ async () => {
            // const options = {
            //   method: 'GET',
            //   headers: {
            //     'Accept': 'application/json',
            //     'Content-type': 'application/json',
            //     'Authorization': `Bearer ${localStorage.getItem('token')}`,
            //   },
            // };
            const response = await axiosApi('/');
      
            if (response.status == 200) {
              setProducts(await response.data);
            } else {
              alert("Dados não localizados");
            }
          }}
        >
          Consultar
        </button>
        </div>
      </div>
      { products && products.products.length > 0 &&
        <div>
          <div className="transfer_total">
            <span className="total_balance" data-testid="saldo-total">Quantidade: {products.products.length}</span>
          </div>
        <table className="transfer_table">
        <thead>
          <tr>
            <th>Controle</th>
            <th>Produto</th>
            <th>Unidade</th>
            <th>Quantidade</th>
            <th>Custo</th>
            <th>Venda</th>
          </tr>
        </thead>
        <tbody>
          { currentTableData.map((product) => (
            <tr key={ product.controle }>
              <td>{product.controle}</td>
              <td>{product.produto}</td>
              <td>{product.unidade}</td>
              <td>{product.qtde}</td>
              <td>{product.precocusto}</td>
              <td>{product.precovenda}</td>
            </tr>
          ) )}
        </tbody>
        </table>
        <Pagination
          className="pagination-bar"
          currentPage={currentPage}
          // totalCount={data.length}
          totalCount={products.products.length}
          pageSize={PageSize}
          onPageChange={page => setCurrentPage(page)}
        />
        </div>
      }
    </>
  )

}

export default ProductsView;