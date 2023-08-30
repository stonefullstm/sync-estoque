import { describe, expect, it } from "vitest"
// import { render, screen, userEvent, act, waitFor } from "../../test-utils";
import { render, screen, act } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import App from '../App';

let accountInput;
let initialInput;
let finalInput;
let operadorInput;
let button;

beforeEach(() => {
  render(<App />);
  accountInput = screen.getByTestId('bank-account');
  initialInput = screen.getByTestId('initial-date');
  finalInput = screen.getByTestId('final-date');
  operadorInput = screen.getByTestId('operador');
  button = screen.getByRole('button');
});

describe('Testar página BankStatement', () => {

  it('Elementos deveriam renderizar', () => {
    const titulo = screen.getByText(/Bank Statement/i);
    expect(titulo).toBeDefined();
    expect(accountInput).toBeDefined();
    expect(initialInput).toBeDefined();
    expect(finalInput).toBeDefined();
    expect(operadorInput).toBeDefined();
    expect(button).toBeDefined();
  })
  it('Inputs deveriam aceitar dados', async () => {
    expect(accountInput).toBeDefined();
    expect(initialInput).toBeDefined();
    expect(finalInput).toBeDefined();
    expect(operadorInput).toBeDefined();
    await act(async () => {
      await userEvent.clear(accountInput);
      await userEvent.type(accountInput, '1');
      await userEvent.clear(initialInput);
      await userEvent.type(initialInput, '2023-05-07');
      await userEvent.clear(finalInput);
      await userEvent.type(finalInput, '2023-07-18')
      await userEvent.clear(operadorInput);
      await userEvent.type(operadorInput, 'Sicrano');
    });
    expect(accountInput.value).toBe('1')
    expect(initialInput.value).toBe('2023-05-07');
    expect(finalInput.value).toBe('2023-07-18');
    expect(operadorInput.value).toBe('Sicrano');
  })
});

describe('Testar chamada de fetch e renderização das transferencias', () => {

  it('Deveria chamar fetch e renderizar transferencias de uma conta ao clicar no botão /Consultar/', async () => {
    // render(<App />);
    // const accountInput = screen.getByTestId('bank-account');
    expect(accountInput).toBeDefined();
    // const button = screen.getByRole('button');
    await act(async () => {
      await userEvent.clear(accountInput);
      await userEvent.type(accountInput, '1');
      await userEvent.click(button);
    });
    const saldoTotal = screen.getByTestId('saldo-total');
    expect(saldoTotal).toBeDefined();
    let filas = screen.queryAllByRole('row');
    expect(filas).toHaveLength(11);
  });
  
  it('Deveria exibir botões de paginação e mudar de página ao clicar botão', async () => {
    // render(<App />);
    // const accountInput = screen.getByTestId('bank-account');
    expect(accountInput).toBeDefined();
    // const button = screen.getByRole('button');
    await act(async () => {
      await userEvent.clear(accountInput);
      await userEvent.type(accountInput, '1');
      await userEvent.click(button);
    });
    const saldoTotal = screen.getByTestId('saldo-total');
    expect(saldoTotal).toBeDefined();
    let filas = screen.queryAllByRole('row');
   
    let buttons = screen.queryAllByTestId(/page-number-/i);
    expect(buttons).toHaveLength(2);
    await act(async () => {
      await userEvent.click(buttons[1]);
    })
    filas = screen.queryAllByRole('row');
    expect(filas).toHaveLength(3);  
  });

  it('Deveria chamar fetch e rendererizar transferencias de uma conta/operador ao clicar no botão /Consultar/', async () => {
    // render(<App />);
    // const accountInput = screen.getByTestId('bank-account');
    expect(accountInput).toBeDefined();
    // const button = screen.getByRole('button');
    // const operadorInput = screen.getByTestId('operador');
    expect(operadorInput).toBeDefined();
    await act(async () => {
      await userEvent.clear(accountInput);
      await userEvent.type(accountInput, '1');
      await userEvent.clear(operadorInput);
      await userEvent.type(operadorInput, 'Beltrano');
      await userEvent.click(button);
    });
    const saldoTotal = screen.getByTestId('saldo-total');
    console.log('saldo' + saldoTotal);
    expect(saldoTotal).toBeDefined();
    const filas = screen.queryAllByRole('row');
    expect(filas).toHaveLength(2);
  });

  it('Deveria chamar fetch e rendererizar transferencias de uma conta/intervalo de datas ao clicar no botão /Consultar/', async () => {
    // render(<App />);
    // const accountInput = screen.getByTestId('bank-account');
    expect(accountInput).toBeDefined();
    // const button = screen.getByRole('button');
    // const initialInput = screen.getByTestId('initial-date');
    expect(initialInput).toBeDefined();
    // const finalInput = screen.getByTestId('final-date');
    expect(finalInput).toBeDefined();
    await act(async () => {
      await userEvent.clear(accountInput);
      await userEvent.type(accountInput, '1');
      await userEvent.clear(initialInput);
      await userEvent.type(initialInput, '2019-01-01');
      await userEvent.clear(finalInput);
      await userEvent.type(finalInput, '2019-05-06')
      await userEvent.click(button);
    });
    const saldoTotal = screen.getByTestId('saldo-total');
    expect(saldoTotal).toBeDefined();
    const filas = screen.queryAllByRole('row');
    expect(filas).toHaveLength(3);
  });

});
