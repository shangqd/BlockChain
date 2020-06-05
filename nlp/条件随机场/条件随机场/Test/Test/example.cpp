#include <iostream>
#include <map>

#include <boost/tokenizer.hpp>
#include "crfpp.h"

std::map<std::string, CRFPP::Tagger *> models;

CRFPP::Tagger* GetModel(const std::string &model_name)
{
	auto ite = models.find(model_name);
	if (ite == models.end())
	{
		std::string cmd("-m ");
		cmd += model_name;
		CRFPP::Tagger *m = CRFPP::createTagger(cmd.c_str());
		models.insert(make_pair(model_name, m));
		return m;
	}
	else
	{
		return ite->second;
	}
}
extern "C" __declspec(dllexport) void CRF_Colse(char *model_name)
{
	auto ite = models.find(model_name);
	if (ite != models.end())
	{
		ite->second->close();
		models.erase(ite);
	}
}

extern "C" __declspec(dllexport) int CRF(char *model_name, char *str_in, char *str_out, int len)
{
	CRFPP::Tagger *tagger = GetModel(model_name);	
	tagger->clear();
	std::string line(str_in);
	boost::tokenizer<boost::char_separator<char>> tokens(line, boost::char_separator<char>("\n"));
	for (auto it = tokens.begin(); it != tokens.end(); ++it)
	{
		tagger->add((*it).c_str());
	}
	if (!tagger->parse()) return -1;
	std::string res;
	for (size_t i = 0; i < tagger->size(); ++i)
	{
		res += tagger->y2(i);
		res += "\n";
	}
	strcpy_s(str_out,len,res.c_str());
	return strlen(str_out);
}


int main(int argc, char **argv) 
{
	//tagger->add("expected VBN");
	//tagger->add("to TO");
	//tagger->add("take VB");
	//tagger->add("another DT");
	//tagger->add("sharp JJ");
	//tagger->add("dive NN");
	//tagger->add("if IN");
	//tagger->add("trade NN");
	//tagger->add("figures NNS");
	//tagger->add("for IN");
	//tagger->add("September NNP");
	char *s1 = "Confidence NN\nin IN\nthe DT\npound NN\nis VBZ\nwidely RB\n";
	char s2[100];
	CRF("E:\\条件随机场\\CRF++-0.53\\example\\chunking\\model",s1,s2,100);
	CRFPP::Tagger *tagger = CRFPP::createTagger("-m E:\\条件随机场\\CRF++-0.53\\example\\chunking\\model");
	if (!tagger) 
	{
		std::cerr << CRFPP::getTaggerError() << std::endl;
		return -1;
	}

	// clear internal context
	tagger->clear();

	// add context
	tagger->add("Confidence NN");
	tagger->add("in IN");
	tagger->add("the DT");
	tagger->add("pound NN");
	tagger->add("is VBZ");
	tagger->add("widely RB");
	tagger->add("expected VBN");
	tagger->add("to TO");
	tagger->add("take VB");
	tagger->add("another DT");
	tagger->add("sharp JJ");
	tagger->add("dive NN");
	tagger->add("if IN");
	tagger->add("trade NN");
	tagger->add("figures NNS");
	tagger->add("for IN");
	tagger->add("September NNP");


	// parse and change internal stated as 'parsed'
	if (! tagger->parse()) return -1;

  
	for (size_t i = 0; i < tagger->size(); ++i) 
	{
		for (size_t j = 0; j < tagger->xsize(); ++j) 
		{
			std::cout << tagger->x(i, j) << '\t';
		}
		std::cout << tagger->y2(i) << '\t';
		std::cout << std::endl;
	}
	std::cout << "Done" << std::endl;
}
