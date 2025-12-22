-- AlterTable
ALTER TABLE "CartItem" ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "notes" TEXT;

-- AlterTable
ALTER TABLE "DeliveryProfile" ADD COLUMN     "is_available" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "Order" ADD COLUMN     "delivered_at" TIMESTAMP(3),
ADD COLUMN     "payment_method" TEXT NOT NULL DEFAULT 'cash';

-- AlterTable
ALTER TABLE "OrderItem" ADD COLUMN     "notes" TEXT;

-- AlterTable
ALTER TABLE "OrderStatusLog" ADD COLUMN     "notes" TEXT;

-- AlterTable
ALTER TABLE "Restaurant" ADD COLUMN     "delivery_fee" DOUBLE PRECISION NOT NULL DEFAULT 0,
ADD COLUMN     "delivery_time_max" INTEGER,
ADD COLUMN     "delivery_time_min" INTEGER,
ADD COLUMN     "minimum_order" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- CreateIndex
CREATE INDEX "DeliveryProfile_is_available_idx" ON "DeliveryProfile"("is_available");

-- AddForeignKey
ALTER TABLE "Cart" ADD CONSTRAINT "Cart_restaurant_id_fkey" FOREIGN KEY ("restaurant_id") REFERENCES "Restaurant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
