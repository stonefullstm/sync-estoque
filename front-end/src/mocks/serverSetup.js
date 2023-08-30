// source: https://relatablecode.com/testing-a-react-application-integrating-msw-with-vitest
import { setupServer } from 'msw/node';
import getHandler from './getHandler';
// import getOperatorHandler from './getOperatorHandler';

const server = setupServer(getHandler)

export {
  server,
}
