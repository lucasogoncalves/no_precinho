const express = require('express');
const cors = require('cors');
const pool = require('./db');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// [GET] Listar todos os produtos
app.get('/produtos', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT * FROM produtos ORDER BY id DESC');
    res.json(rows);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao buscar produtos', detalhes: err.message });
  }
});

// [POST] Criar produto
app.post('/produtos', async (req, res) => {
  const { nome, preco, codigo_barras, mercado } = req.body;
  try {
    const query = `
      INSERT INTO produtos (nome, preco, codigo_barras, mercado, registrado_em)
      VALUES ($1, $2, $3, $4, NOW())
      RETURNING *;
    `;
    const { rows } = await pool.query(query, [nome, preco, codigo_barras, mercado]);
    res.status(201).json(rows[0]);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao criar produto', detalhes: err.message });
  }
});


// [PUT] Atualizar produto
app.put('/produtos/:id', async (req, res) => {
  const { id } = req.params;
  const { nome, preco, codigo_barras, mercado } = req.body;

  try {
    const query = `
      UPDATE produtos
      SET nome = $1, preco = $2, codigo_barras = $3, mercado = $4, registrado_em = NOW()
      WHERE id = $5
      RETURNING *;
    `;
    const valores = [nome, preco, codigo_barras, mercado, id];
    const { rows } = await pool.query(query, valores);

    if (rows.length === 0) {
      return res.status(404).json({ erro: 'Produto não encontrado' });
    }

    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao atualizar produto', detalhes: err.message });
  }
});


// [DELETE] Remover produto
app.delete('/produtos/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const query = `DELETE FROM produtos WHERE id = $1 RETURNING *;`;
    const { rows } = await pool.query(query, [id]);
    if (rows.length === 0) {
      return res.status(404).json({ erro: 'Produto não encontrado' });
    }
    res.json({ mensagem: 'Produto excluído com sucesso' });
  } catch (err) {
    res.status(500).json({ erro: 'Erro ao excluir produto', detalhes: err.message });
  }
});

const port = process.env.PORT || 3000;
app.listen(port, () => {
  console.log(`✅ API online na porta ${port}`);
});
