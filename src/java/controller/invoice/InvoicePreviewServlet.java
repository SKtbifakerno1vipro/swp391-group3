package controller.invoice;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dto.InvoiceItemDTO;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "InvoicePreviewServlet", urlPatterns = {"/preview"})
public class InvoicePreviewServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        try {
            String[] prodIds = request.getParameterValues("productId");
            String[] prodNames = request.getParameterValues("productName");
            String[] units = request.getParameterValues("unit");
            String[] quantities = request.getParameterValues("quantity");
            String[] sellingPrices = request.getParameterValues("sellingPrice");
            String[] discountPercents = request.getParameterValues("discountPercent");
            String[] taxPercents = request.getParameterValues("taxPercent");
            String[] lineTaxes = request.getParameterValues("lineTax");

            List<InvoiceItemDTO> orderDetails = new ArrayList<>();

            if (prodIds != null) {
                for (int i = 0; i < prodIds.length; i++) {
                    int productId = Integer.parseInt(prodIds[i]);
                    String productName = prodNames[i];
                    String unit = units[i];
                    int quantity = 0;
                    if (quantities != null && i < quantities.length && quantities[i] != null && !quantities[i].isEmpty()) {
                        try {
                            quantity = (int) Double.parseDouble(quantities[i]);
                        } catch (NumberFormatException e) {
                            quantity = 0;
                        }
                    }
                    double sellingPrice = 0.0;
                    if (sellingPrices != null && i < sellingPrices.length && sellingPrices[i] != null && !sellingPrices[i].isEmpty()) {
                        try {
                            sellingPrice = Double.parseDouble(sellingPrices[i]);
                        } catch (NumberFormatException e) {
                            sellingPrice = 0.0;
                        }
                    }
                    double discountPercent = 0.0;
                    if (discountPercents != null && i < discountPercents.length && discountPercents[i] != null && !discountPercents[i].isEmpty()) {
                        try {
                            discountPercent = Double.parseDouble(discountPercents[i].replace("%", "").trim());
                        } catch (NumberFormatException e) {
                            discountPercent = 0.0;
                        }
                    }
                    double taxPercent = 0.0;
                    if (taxPercents != null && i < taxPercents.length && taxPercents[i] != null && !taxPercents[i].isEmpty()) {
                        try {
                            taxPercent = Double.parseDouble(taxPercents[i].replace("%", "").trim());
                        } catch (NumberFormatException e) {
                            taxPercent = 0.0;
                        }
                    }

                    double lineAmount = quantity * sellingPrice;
                    double lineDiscount = lineAmount * (discountPercent / 100.0);
                    double lineTax = 0.0;
                    if (lineTaxes != null && i < lineTaxes.length && lineTaxes[i] != null && !lineTaxes[i].isEmpty()) {
                        try {
                            lineTax = Double.parseDouble(lineTaxes[i]);
                        } catch (NumberFormatException e) {
                            lineTax = (lineAmount - lineDiscount) * (taxPercent / 100.0);
                        }
                    } else {
                        lineTax = (lineAmount - lineDiscount) * (taxPercent / 100.0);
                    }

                    InvoiceItemDTO item = new InvoiceItemDTO(
                        productId, productName, unit, quantity, sellingPrice,
                        discountPercent, taxPercent, lineDiscount, lineTax
                    );
                    orderDetails.add(item);
                }
            }
            request.setAttribute("orderDetails", orderDetails);
            
            String invoiceType = request.getParameter("invoiceType");
            String invoiceSymbol = request.getParameter("invoiceSymbol");
            String invoiceNo = request.getParameter("invoiceNo");
            String issueDate = request.getParameter("issueDate");
            String invoiceStatus = request.getParameter("invoiceStatus");

            if (invoiceStatus == null || "UNRELEASED".equals(invoiceStatus) || invoiceNo == null || "0".equals(invoiceNo) || invoiceNo.startsWith("DFT")) {
                invoiceNo = "Not assigned (Auto-generated)";
                issueDate = "Auto-retrieved upon release";
            }

            String sellerName = request.getParameter("sellerName");
            String sellerTaxCode = request.getParameter("sellerTaxCode");
            String sellerAddress = request.getParameter("sellerAddress");
            String sellerPhone = request.getParameter("sellerPhone");

            String buyerName = request.getParameter("buyerName");
            String buyerTaxCode = request.getParameter("buyerTaxCode");
            String buyerAddress = request.getParameter("buyerAddress");
            String buyerPhone = request.getParameter("buyerPhone");

            String subTotalRaw = request.getParameter("subTotal");
            String discountTotalRaw = request.getParameter("discountTotal");
            String taxAmountRaw = request.getParameter("taxAmount");
            String totalAmountRaw = request.getParameter("totalAmount");

            double subTotal = (subTotalRaw != null && !subTotalRaw.isEmpty()) ? Double.parseDouble(subTotalRaw) : 0.0;
            double discountTotal = (discountTotalRaw != null && !discountTotalRaw.isEmpty()) ? Double.parseDouble(discountTotalRaw) : 0.0;
            double taxAmount = (taxAmountRaw != null && !taxAmountRaw.isEmpty()) ? Double.parseDouble(taxAmountRaw) : 0.0;
            double totalAmount = (totalAmountRaw != null && !totalAmountRaw.isEmpty()) ? Double.parseDouble(totalAmountRaw) : 0.0;

            String amountInWords = convertNumberToWords((long) totalAmount);

            request.setAttribute("invoiceType", invoiceType);
            request.setAttribute("invoiceSymbol", invoiceSymbol);
            request.setAttribute("invoiceNo", invoiceNo);
            request.setAttribute("issueDate", issueDate);
            request.setAttribute("invoiceStatus", invoiceStatus);
            
            request.setAttribute("sellerName", sellerName);
            request.setAttribute("sellerTaxCode", sellerTaxCode);
            request.setAttribute("sellerAddress", sellerAddress);
            request.setAttribute("sellerPhone", sellerPhone);
            
            request.setAttribute("buyerName", buyerName);
            request.setAttribute("buyerTaxCode", buyerTaxCode);
            request.setAttribute("buyerAddress", buyerAddress);
            request.setAttribute("buyerPhone", buyerPhone);
            
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("discountTotal", discountTotal);
            request.setAttribute("taxAmount", taxAmount);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("amountInWords", amountInWords);

            request.getRequestDispatcher("/views/invoice/template.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorInvoice", "Lỗi xem trước hóa đơn");
            response.sendRedirect("/invoice-list");
        }
    }

    private String convertNumberToWords(long number) {
        if (number == 0) return "Không đồng";
        
        String prefix = "";
        if (number < 0) {
            prefix = "âm ";
            number = -number;
        }

        String[] units = {"", "một", "hai", "ba", "bốn", "năm", "sáu", "bảy", "tám", "chín"};
        String[] scales = {"", "nghìn", "triệu", "tỷ", "nghìn", "triệu", "tỷ", "nghìn", "triệu", "tỷ"};

        List<Integer> groups = new ArrayList<>();
        long temp = number;
        while (temp > 0) {
            groups.add((int) (temp % 1000));
            temp /= 1000;
        }

        StringBuilder result = new StringBuilder(prefix);

        for (int i = groups.size() - 1; i >= 0; i--) {
            int n = groups.get(i);

            if (n == 0 && i % 3 != 0) {
                continue;
            }

            boolean showZeroHundred = (i < groups.size() - 1);
            int hundred = n / 100;
            int ten = (n % 100) / 10;
            int unit = n % 10;

            StringBuilder groupText = new StringBuilder();

            if (hundred > 0) {
                groupText.append(units[hundred]).append(" trăm ");
            } else if (showZeroHundred && (ten > 0 || unit > 0)) {
                groupText.append(" không trăm ");
            }

            if (ten > 1) {
                groupText.append(units[ten]).append(" mươi ");
            } else if (ten == 1) {
                groupText.append(" mười ");
            } else if (ten == 0 && unit > 0 && (hundred > 0 || showZeroHundred)) {
                groupText.append(" lẻ ");
            }

            if (unit == 5 && ten > 0) {
                groupText.append(" lăm ");
            } else if (unit == 1 && ten > 1) {
                groupText.append(" mốt ");
            } else if (unit > 0) {
                groupText.append(units[unit]);
            }

            String groupStr = groupText.toString().trim();
            if (!groupStr.isEmpty()) { 
                result.append(groupStr).append(" ");
                if (i < scales.length) {
                    result.append(scales[i]).append(" ");
                }
            } else if (i > 0 && i % 3 == 0) { 
                if (i < scales.length) {
                    result.append(scales[i]).append(" ");
                }
            }
        }

        String rawWords = result.toString().replaceAll("\\s+", " ").trim();
        if (rawWords.isEmpty()) return "Không đồng";

        return rawWords.substring(0, 1).toUpperCase() + rawWords.substring(1) + " đồng";
    }

}
