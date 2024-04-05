import { prisma } from "../src/lib/prisma";

async function seed() {
  await prisma.event.create({
    data: {
      id: "a18f0b8a-d368-452b-a2ee-6419736840fe",
      title: "NLW Summit",
      slug: "nlw-summit",
      details: "Um evento para programadores apaixonados.",
      maximumAttendees: 120,
    }
  })
};

seed().then(() => {
  console.log("Database seeded!");
  prisma.$disconnect();
})