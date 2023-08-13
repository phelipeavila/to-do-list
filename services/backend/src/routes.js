const express = require("express");
const { PrismaClient } = require("@prisma/client");

const prisma = new PrismaClient();
const toDoRoutes = express.Router();

toDoRoutes.post("/to-do", async (req, res) => {
  const { name } = req.body;

  try {
    const todo = await prisma.todo.create({
      data: {
        name,
      },
    });
    res.status(201).json(todo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to create to-do." });
  }
});

toDoRoutes.get("/to-do", async (req, res) => {
  try {
    const todos = await prisma.todo.findMany();
    res.status(200).json(todos);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to fetch to-do." });
  }
});

toDoRoutes.put("/to-do/:id", async (req, res) => {
  const { id } = req.params;
  const { name, status } = req.body;

  try {
    const updatedTodo = await prisma.todo.update({
      where: {
        id: parseInt(id),
      },
      data: {
        name,
        status,
      },
    });

    res.status(200).json(updatedTodo);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to update to-do." });
  }
});

toDoRoutes.delete("/to-do/:id", async (req, res) => {
  const { id } = req.params;

  try {
    await prisma.todo.delete({
      where: {
        id: parseInt(id),
      },
    });

    res.status(200).json({ message: "Todo deleted successfully." });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to delete to-do." });
  }
});

module.exports = toDoRoutes;
