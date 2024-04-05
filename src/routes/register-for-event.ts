import { FastifyInstance } from "fastify";
import { ZodTypeProvider } from "fastify-type-provider-zod";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function registerForEvent(app: FastifyInstance) {
  app
    .withTypeProvider<ZodTypeProvider>()
    .post("/events/:eventId/attendees", {
      schema: {
        summary: "Register attendee for event",
        tags: ["events"],
        body: z.object({
          name: z.string().min(4),
          email: z.string().email()
        }),
        params: z.object({
          eventId: z.string().uuid()
        }),
        response: {
          201: z.object({ attendeeId: z.number() })
        }
      }
    }, async (request, reply) => {
      const { name, email } = request.body;
      const { eventId } = request.params;

      const attendeeFromEventExists = await prisma.attendee.findUnique({
        where: {
          eventId_email: {
            eventId,
            email
          }
        }
      });

      if (attendeeFromEventExists !== null) {
        throw new Error("Attendee with this email already has been created for this event.");
      }

      const [event, amountOfAttendeesForEvent] = await Promise.all([
        prisma.event.findUnique({
          where: {
            id: eventId
          }
        }),
        prisma.attendee.count({
          where: {
            eventId
          }
        })
      ])

      if (event?.maximumAttendees && amountOfAttendeesForEvent >= event.maximumAttendees) {
        throw new Error("Attendees limit already been reached!");
      }

      const createdAttendee = await prisma.attendee.create({
        data: {
          name,
          email,
          eventId
        }
      });

      reply.status(201).send({ attendeeId: createdAttendee.id });
    })
}