export const converteData = (data) => {
  return (new Date(data)).toLocaleString('pt-BR', { timezone: 'UTC' });
}
