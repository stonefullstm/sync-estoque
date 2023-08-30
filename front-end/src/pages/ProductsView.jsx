import { useState, useMemo } from "react";
import Pagination from "../components/Pagination";
import { myFetch } from "../services/fetch";
import "../styles/BankStatement.css";
import { converteData } from "../services/dateUtil";

const PageSize = 10;

function ProductsView() {
  const [account, setAccount] = useState('');
  const [initialDate, setInitialDate] = useState('');
  const [finalDate, setFinalDate] = useState('');
  const [operador, setOperador] = useState('');
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
        <label htmlFor="bank-account" className="bank_account">
          Bank Account:
          <input
            className="input"
            data-testid="bank-account"
            type="number"
            value={ account }
            onChange={ ({ target }) => setAccount(target.value)}
          />
        </label>
        <div className="filters">
        <label htmlFor="initial-date">
          Initital Date:
          <input
            className="input"
            data-testid="initial-date"
            type="date"
            value={ initialDate }
            onChange={ ({ target }) => setInitialDate(target.value)}
          />
        </label>
        <label htmlFor="final-date">
          Final Date:
          <input
            className="input"
            data-testid="final-date"
            type="date"
            value={ finalDate }
            onChange={ ({ target }) => setFinalDate(target.value)}
          />
        </label>
        <label htmlFor="operador">
          Operador:
          <input
            className="input"
            data-testid="operador"
            type="text"
            value={ operador }
            onChange={ ({ target }) => setOperador(target.value)}
          />
        </label>
        <button
          type="button"
          onClick={ async () => {
            const response = await myFetch(
              `estoque`
              );
            if (!response.message) {
              setProducts(response);
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
          </tr>
        </thead>
        <tbody>
          { currentTableData.map((product) => (
            <tr key={ product.controle }>
              <td>{product.controle}</td>
              <td>{product.produto}</td>
              <td>{product.unidade}</td>
              <td>{product.qtde}</td>
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