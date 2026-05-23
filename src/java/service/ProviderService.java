package service;
import dal.ProviderDAO;
import java.util.List;
import model.Provider;
import dto.ProviderDTO;
import model.User;
public class ProviderService {
    private final ProviderDAO providerDAO = new ProviderDAO();
    public List<Provider> getAllProviders() { return providerDAO.getAllProviders(); }
    public ProviderDTO getProviderDTOByProviderId(int id) { return providerDAO.getProviderDTOByProviderId(id); }
    public Provider createProvider(Provider provider) { return providerDAO.createProvider(provider); }
    public Provider createUserAndProvider(User user, Provider provider) { return providerDAO.createUserAndProvider(user, provider); }
}