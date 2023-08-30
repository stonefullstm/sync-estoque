// source: https://relatablecode.com/testing-a-react-application-integrating-msw-with-vitest

import { rest } from 'msw';
import { paginationData, operatorData, periodData } from './testData';

const getHandler = rest.get('http://localhost:8080/transferencias/:id', (req, res, ctx) => {
  // eslint-disable-next-line no-unused-vars
  const { id } = req.params;
  // eslint-disable-next-line no-unused-vars
  const operador = req.url.searchParams.get('operador');
  const datainicial = req.url.searchParams.get('datainicial');
  const datafinal = req.url.searchParams.get('datafinal');
  let data = paginationData;
  if (operador && !datainicial && !datafinal || operador && datainicial && datafinal) {
    data = operatorData
  } else if (!operador && datainicial && datafinal) {
    data = periodData
  }
  return res(
    ctx.status(200),
    ctx.json(data)
  )
});

export default getHandler;

