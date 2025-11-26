import 'package:get/get.dart';
import '../data/models/crypto_data.dart';
import '../data/models/chart_data.dart';
import '../data/providers/crypto_api_provider.dart';

class CryptoController extends GetxController {
  final CryptoApiProvider _apiProvider = CryptoApiProvider();

  var cryptoList = <CryptoData>[].obs;
  var chartData = <ChartData>[].obs;
  var isLoading = false.obs;
  var selectedCrypto = Rx<CryptoData?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    try {
      isLoading.value = true;
      cryptoList.value = await _apiProvider.fetchCryptoList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch crypto data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchChartData(String coinId) async {
    try {
      isLoading.value = true;
      chartData.value = await _apiProvider.fetchChartData(coinId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch chart data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectCrypto(CryptoData crypto) {
    selectedCrypto.value = crypto;
    fetchChartData(crypto.id);
  }
}