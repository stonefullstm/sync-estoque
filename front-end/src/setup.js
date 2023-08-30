// source: https://relatablecode.com/testing-a-react-application-integrating-msw-with-vitest
import { server } from './mocks/serverSetup';

beforeAll(() => server.listen({ onUnhandledRequest: 'error' }));
afterAll(() => server.close());
afterEach(() => server.resetHandlers());
