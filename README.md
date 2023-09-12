# Sync Estoque

Aqui você encontrará os detalhes sobre o projeto: como instalar, executar, funcionalidades, recursos e tecnologias utilizadas.

## Status do projeto

<p align="center">
<img src="https://img.shields.io/badge/STATUS-EM DESENVOLVIMENTO-blue"/>
</p>

## Introdução

O **Sync Estoque** é uma aplicação constituída de três módulos. Uma API REST desenvolvida em Python/FastAPI, que permite sincronização de dados de estoque com uma aplicação *standalone*, que usa banco de dados [Firebird](https://firebirdsql.org/). Uma aplicação standalone desenvolvida em [Lazarus](https://www.lazarus-ide.org/), a qual realiza o processo de sincronização. E a aplicação *front-end* desenvolvida em [React.js](https://react.dev/), a qual acessa a API. A finalidade principal da aplicação é oferecer ao cliente o recurso de consultar seu estoque de qualquer lugar e, assim, tomar decisão em relação a pedidos de compras para reposição de estoque. 

## Instalação e execução

### Back-end ###

### Módulo *standalone* em Lazarus ###

### Front-end ###
1. Inicialmente, clone o repositório com o comando `git clone git@github.com:stonefullstm/sync-estoque.git`
2. Na raiz do repositório clonado, execute `cd front-end` e `npm install` a fim de instalar as dependências
3. Execute `npm run dev` para iniciar a aplicação
4. A aplicação deve executar no navegador em `http://localhost:5173/`

## Funcionalidades

## Tecnologias utilizadas

No *front-end*: linguagem de programação [Javascript](https://developer.mozilla.org/pt-BR/docs/Web/JavaScript), a biblioteca front end  [React.js](https://react.dev/), e a ferramenta de construção [Vite.js](https://vitejs.dev/). No *back-end*: linguagem de programação [Python](https://www.python.org/), framework [FastAPI](https://fastapi.tiangolo.com/) e banco de dados [PostgreSQL](https://www.postgresql.org/). No módulo *standalone*: linguagem de programação [FreePascal](https://www.freepascal.org/) e IDE [Lazarus](https://www.lazarus-ide.org/).