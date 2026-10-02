module Admin
  class ShipmentsController < BaseController
    def index
      @shipments = ShippingShipment.order(created_at: :desc)
    end

    def show
      @shipment = ShippingShipment.find(params[:id])
    end

    def update_status
      @shipment = ShippingShipment.find(params[:id])
      new_status = params[:status]
      notes = params[:notes]

      if ShippingShipment::STATUSES.include?(new_status)
        @shipment.advance_checkpoint!(new_status, notes)
        redirect_to admin_shipment_path(@shipment), notice: "Cross-border checkpoint updated to: #{new_status.humanize}"
      else
        redirect_to admin_shipment_path(@shipment), alert: "Invalid shipment status"
      end
    end
  end
end
