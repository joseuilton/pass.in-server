import { PrismaClient } from "@prisma/client";
import fastify from "fastify";
import { z } from "zod";

const app = fastify();
const prisma = new PrismaClient({
  log: ["query"]
});

app.post("/events", async (request, reply) => {
  const createEventSchema = z.object({
    title: z.string().min(4),
    details: z.string().nullable(),
    maximumAttendees: z.number().int().positive().nullable()
  });

  const data = createEventSchema.parse(request.body);

  const createdEvent = await prisma.event.create({
    data: {
      title: data.title,
      details: data.details,
      maximumAttendees: data.maximumAttendees,
      slug: new Date().toISOString()
    }
  });

  return reply.status(201).send({ eventId: createdEvent.id });
});

app.listen({ port: 3333 }).then(() => {
  console.log("HTTP server running");
});