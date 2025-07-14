require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { Pool } = require('pg');

const app = express();
app.use(cors());
app.use(express.json());

// Conexão com PostgreSQL usando variável de ambiente
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// Rota GET: listar todos os itens
app.get('/itens', async (req, res) => {
  try {
    const resultado = await pool.query('SELECT * FROM itens ORDER BY id DESC');
    res.json(resultado.rows);
  } catch (err) {
    console.error('Erro ao listar itens:', err);
    res.status(500).json({ erro: 'Erro interno ao listar itens' });
  }
});

// Rota POST: adicionar novo item
app.post('/itens', async (req, res) => {
  try {
    const { nome } = req.body;
    const resultado = await pool.query(
      'INSERT INTO itens (nome) VALUES ($1) RETURNING *',
      [nome]
    );
    res.status(201).json(resultado.rows[0]);
  } catch (err) {
    console.error('Erro ao adicionar item:', err);
    res.status(500).json({ erro: 'Erro interno ao adicionar item' });
  }
});

// Rota DELETE: excluir item por ID
app.delete('/itens/:id', async (req, res) => {
  try {
    const { id } = req.params;
    await pool.query('DELETE FROM itens WHERE id = $1', [id]);
    res.sendStatus(204);
  } catch (err) {
    console.error('Erro ao deletar item:', err);
    res.status(500).json({ erro: 'Erro interno ao deletar item' });
  }
});

// Porta do servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
