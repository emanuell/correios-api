$LOAD_PATH << File.expand_path(File.dirname(__FILE__) + "/../lib")

require 'pacote'
require "correios"
require "encomenda"
require "encomenda_status"

describe Encomenda do
  it "deveria parsear o html dos correios corretamente" do
    url = File.dirname(__FILE__) + "/exemplo_rastreamento_correios.html"
    encomenda = Correios.encomenda("", url=url)
    
    encomenda.numero.should eql("")
    encomenda.status.should_not be_empty
    
    status = encomenda.status[0]
    status.data.should eql(DateTime.parse("2009-01-27T16:35:00+00:00"))
    status.local.should eql("ACF FENIX - ITAPECERICA DA SERRA/SP")
    status.situacao.should eql("Postado")
    status.detalhes.should be_nil
    
    status = encomenda.status[1]
    status.data.should eql(DateTime.parse("2009-01-27T18:51:00+00:00"))
    status.local.should eql("ACF FENIX - ITAPECERICA DA SERRA/SP")
    status.situacao.should eql("Encaminhado")
    status.detalhes.should eql("Em trânsito para CTE JAGUARE - SAO PAULO/SP")
    
    status = encomenda.status[2]
    status.data.should eql(DateTime.parse("2009-01-28T03:36:00+00:00"))
    status.local.should eql("CTE JAGUARE - SAO PAULO/SP")
    status.situacao.should eql("Encaminhado")
    status.detalhes.should eql("Encaminhado para CTE SAUDE - SAO PAULO/SP")
    
    status = encomenda.status[3]
    status.data.should eql(DateTime.parse("2009-01-28T06:40:00+00:00"))
    status.local.should eql("CTE SAUDE - SAO PAULO/SP")
    status.situacao.should eql("Encaminhado")
    status.detalhes.should eql("Encaminhado para CEE MOEMA - SAO PAULO/SP")
    
    status = encomenda.status[4]
    status.data.should eql(DateTime.parse("2009-01-28T14:17:00+00:00"))
    status.local.should eql("CEE MOEMA - SAO PAULO/SP")
    status.situacao.should eql("Saiu para entrega")
    status.detalhes.should be_nil
    
    status = encomenda.status[5]
    status.data.should eql(DateTime.parse("2009-01-28T17:49:00+00:00"))
    status.local.should eql("CEE MOEMA - SAO PAULO/SP")
    status.situacao.should eql("Entregue")
    status.detalhes.should be_nil
  end
  
  it "deveria retornar o pacote com o valor de envio" do
    pacote = Correios.sedex(:origem => '58701050',
                            :destino => '58701020',
                            :peso => 20,
                            :opcionais => [:ar, :mao_propria, {:valor_declarado => 100.0}])
                            
    pacote.should_not be_nil
    pacote.should be_instance_of(Pacote)
    
    pacote.origem.should eql("58701050")
    pacote.destino.should eql("5870120")
    pacote.peso.should eql(20)
    pacote.should be_ar
    pacote.should be_mao_propria
    pacote.should be_valor_declarado
    pacote.valor_declarado eql(100.0)
    
    pacote.total.should eql()
    
  end
end